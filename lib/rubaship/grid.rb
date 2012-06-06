module Rubaship

  class Grid
    include Enumerable

    ROWS = ("A".."J").to_a
    COLS = ("1".."10").to_a

    POSITION_REGEXP = /^(?<anchor>[A-Z0-9]{2,3}):(?<orientation>[a-z]{1,10})$/i
    ANCHOR_REGEXP = /^(?:(?<row>[A-J])(?<col>([1-9])|10)|\g<col>\g<row>)$/i
    ORIENT_REGEXP = /^(?<ori>
      h(o(r(i(z(o(n(t(a(l)?)?)?)?)?)?)?)?)? |
      v(e(r(t(i(c(a(l)?)?)?)?)?)?)?)$/ix

    def initialize
      @grid = Array.new(10) { Array.new(10) { Sector.new } }
    end

    def initialize_copy(orig)
      s = orig.enum_for(:each_sector)
      @grid = Array.new(10) { Array.new(10) { s.next.dup } }
    end

    def ==(o)
      return case o
        when Hash  then to_hash == o
        when Array then self.to_a == o
        when Grid then self.to_a == o.to_a
      end
    end

    def [](idx1, idx2=nil)
      row = self.row(idx1) if idx1.is_a? Symbol or
                              (idx1.is_a? String and ROWS.include?(idx1)) or
                              (idx1.is_a? Range and ROWS.include?(idx1.min.to_s))
      col = self.col(idx1) if idx1.is_a? Fixnum or
                              (idx1.is_a? String and COLS.include?(idx1)) or
                              (idx1.is_a? Range and COLS.include?(idx1.min.to_s))
      grid = row ? row : col
      return grid if idx2.nil?
      idx2 = row ? Grid.col_to_idx(idx2) : Grid.row_to_idx(idx2)
      if idx1.is_a? Range
        grid = grid.transpose
        if idx2.is_a? Range and row
          grid[idx2].transpose
        else
          grid[idx2]
        end
      else
        grid[idx2]
      end
    end

    def add(ship, row, col, ori)
      self.dup.add!(ship, row, col, ori)
    end

    def add!(ship, row, col, ori=nil)
      row = Grid.row_to_idx(row)
      col = Grid.col_to_idx(col)
      unless ori.nil?
        ori = Grid.ori_to_sym(ori)
        row, col = Grid.rangify_pos(ship, row, col, ori)
      end
      raise InvalidPositionError.new unless Grid.position_valid?(ship, row, col)

      insert_ship = lambda { |sector| sector.ship = ship }
      if col.is_a? Range
        grid = @grid[row][col]
      elsif row.is_a? Range
        grid = @grid.transpose[col][row]
      end
      if v = grid.inject(nil) { |r, sector| r ||= sector.ship }
        raise OverlapShipError.new(v)
      end
      grid.each(&insert_ship)
    end

    def col(col)
      @grid.transpose[Grid.col_to_idx(col)]
    end

    def row(row)
      @grid[Grid.row_to_idx(row)]
    end

    def each
      if block_given?
        @grid.collect do |row|
          row.collect { |sector| yield sector }
        end
      else
        self.to_enum
      end
    end

    alias :each_sector :each

    alias :sectors :each

    def each_col
      if block_given?
        @grid.transpose.each { |col| yield col }
      else
        self.enum_for(:each_col)
      end
    end

    alias :cols :each_col

    def each_row
      if block_given?
        @grid.each { |row| yield row }
      else
        self.enum_for(:each_row)
      end
    end

    alias :rows :each_row

    def sector(row, col)
      self[row, col]
    end

    def to_hash
      @grid.each_with_index.inject({}) do |row_hash, (row, i)|
        row_hash[ROWS[i].to_sym] = row.collect { |sector| sector.to_hash }
        row_hash
      end
    end

    def to_a
      s = self.enum_for(:each_sector)
      Array.new(10) { Array.new(10) { s.next.dup } }
    end

    def to_s(empty=" ", sep="|", col_width=3)
      to_cell = Proc.new do |v|
        sep + (v.is_a?(Sector) ? v.to_s(empty) : v.to_s).center(col_width)
      end
      to_row = Proc.new do |row|
        to_cell.(row[0]) + row[1].map(&to_cell).join + "#{sep}\n"
      end

      str = to_row.([empty] << (1..10).to_a)
      ROWS.zip(self.rows).inject(str) do |s, row|
        s << to_row.(row)
      end
    end

    def self.parse_pos(p)
      return nil unless m = POSITION_REGEXP.match(p)

      anchor, orient = m.captures
      anchor = ANCHOR_REGEXP.match(anchor)
      orient = ORIENT_REGEXP.match(orient)

      unless anchor.nil? or orient.nil?
        format_pos(anchor[1], anchor[2], orient[1])
      end
    end

    def self.position_valid?(ship, row, col)
      range = [row, col].find { |v| v.is_a? Range }
      range.max > 9 ? false : true
    end

    def self.row_to_idx(row)
      return case row
        when Fixnum then row if (0..9).include? row
        when String then row_to_idx(ROWS.index(row.upcase))
        when Symbol then row_to_idx(row.to_s)
        when Range
          return row if row.min.is_a? Fixnum
          row_to_idx(row.min) .. row_to_idx(row.max)
        else raise InvalidRowArgument.new(row)
      end
    end

    def self.col_to_idx(col)
      return case col
        when Fixnum
          raise InvalidColArgument.new(col) unless (1..10).include? col
          (1..10).to_a.index(col)
        when String then col_to_idx(col.ord - '0'.ord)
        when Range
          Range.new(col_to_idx(col.min), col_to_idx(col.max))
        else raise InvalidColArgument.new(col)
      end
    end

    def self.ori_to_sym(ori)
      return case ori
        when String
          if "horizontal" =~ /#{ori}[orizontal]{,#{10 - ori.length}}/i then :H
          elsif "vertical" =~ /#{ori}[ertical]{,#{8 - ori.length}}/i then :V
          else raise InvalidOriArgument.new(ori)
          end
        when Symbol then ori_to_sym(ori.to_s)
        else raise InvalidOriArgument.new(ori)
      end
    end

    def self.format_pos(row, col, ori)
      Array.[](
        row.upcase.to_sym,
        col.ord - '0'.ord,
        ori[0].upcase.to_sym,
      )
    end

    def self.rangify_pos(ship, row, col, ori)
      if ori == :H
        col = (col..col + ship.size - 1) unless col.is_a? Range
      elsif ori == :V
        row = (row..row + ship.size - 1) unless row.is_a? Range
      end
      Array.[](
        row, col
      )
    end
  end

  class Sector

    attr_accessor :ship

    def initialize(ship=nil)
      @ship = ship
    end

    def initialize_copy(orig)
      @ship = orig.ship.is_a?(Ship) ? orig.ship.dup : nil
    end

    def ==(o)
      case o
        when Hash then to_hash == o
        else @ship == o.ship
      end
    end

    def ship=(ship)
      if @ship.nil?
        @ship = ship
      else
        raise OverlapShipError.new(@ship)
      end
    end

    def to_hash
      { :ship => @ship }
    end

    def to_s(empty=" ")
      @ship.nil? ? empty : @ship.to_s
    end
  end
end
