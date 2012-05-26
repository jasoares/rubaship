module Rubaship

  class InvalidRowArgument < ArgumentError; end
  class InvalidColumnArgument < ArgumentError; end
  class InvalidOrientationArgument < ArgumentError; end
  class InvalidShipArgument < ArgumentError; end

  class Board

    ROWS = ("A".."J").to_a

    POSITION_REGEXP = /^(?<anchor>[A-Z0-9]{2,3}):(?<orientation>[a-z]{1,10})$/i
    ANCHOR_REGEXP = /^(?:(?<row>[A-J])(?<col>([1-9])|10)|\g<col>\g<row>)$/i
    ORIENT_REGEXP = /^(?<ori>
      h(o(r(i(z(o(n(t(a(l)?)?)?)?)?)?)?)?)? |
      v(e(r(t(i(c(a(l)?)?)?)?)?)?)?)$/ix

    def initialize
      @board = Array.new(10) { Array.new(10) { Sector.new } }
    end

    def initialize_copy(orig)
      @board = orig.to_a.collect do |row|
        row.collect do |sector|
          sector.dup
        end
      end
    end

    def ==(o)
      return case o
        when Hash  then to_hash == o
        when Array then @board == o
        when Board then @board == o.to_a
      end
    end

    def [](index)
      @board[Board.row_to_idx(index)]
    end

    alias :row :[]

    def add(ship, pos_row, col=nil, ori=:H)
      self.dup.add!(ship, pos_row, col, ori)
    end

    def add!(ship, pos_row, col=nil, ori=:H)
      raise InvalidShipArgument, "Must be a Ship object." unless ship.is_a? Ship
      if col.nil?
        pos_row, col, ori = Board.parse_pos(pos_row) if pos_row.is_a? String
        pos_row, col, ori = pos_row if pos_row.is_a? Array
      end
      begin
        row = Board.row_to_idx(pos_row)
        col = Board.col_to_idx(col)
        ori = Board.ori_to_sym(ori)

        case ori
          when :H
            @board[row][col..col + ship.size - 1].each do |sector|
              sector.ship = ship
            end
          when :V
            @board[row..row + ship.size - 1].each do |r|
              r[col].ship = ship
            end
        end
      rescue ArgumentError
        false
      end
    end

    def col(col)
      @board.collect { |row| row[Board.col_to_idx(col)] }
    end

    def sector(row, col)
      @board[Board.row_to_idx(row)][Board.col_to_idx(col)]
    end

    def to_hash
      @board.each_with_index.inject({}) do |row_hash, (row, i)|
        row_hash[ROWS[i].to_sym] = row.collect { |sector| sector.to_hash }
        row_hash
      end
    end

    def to_a
      @board
    end

    def to_s(empty=" ",sep="|", col_width=3)
      b = self.dup.to_a
      b = b.each_with_index do |row, idx|
        row.insert(0, ROWS[idx])
      end
      b.insert(0, (0..10).to_a)
      b.collect do |row|
        "#{sep}" << row.collect do |cell|
          if cell.is_a? Fixnum
            cell == 0 ? empty.center(col_width) : cell.to_s.center(col_width)
          elsif cell.is_a? String
            cell.center(col_width)
          else
            cell.to_s(empty).center(col_width)
          end
        end.join(sep) << sep
      end.join("\n") << "\n"
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

    def self.row_to_idx(row)
      return case row
        when Fixnum then row
        when String then ROWS.index(row.upcase)
        when Symbol then row_to_idx(row.to_s)
        when Range
          if row.first.is_a? Fixnum
            row
          else
            Range.new(row_to_idx(row.min), row_to_idx(row.max))
          end
        else raise InvalidRowArgument,
          "Invalid row or range type passed #{row}:#{row.class}"
      end
    end

    def self.col_to_idx(col, array=true)
      return case col
        when Fixnum then array ? col - 1 : col
        when String then col_to_idx(col.ord - '0'.ord, array)
        when Range
          Range.new((col_to_idx(col.min, array)), col_to_idx(col.max, array))
        else raise InvalidColumnArgument,
          "Invalid column or range type passed #{col}:#{col.class}"
      end
    end

    def self.ori_to_sym(ori)
      return case ori
        when String
          if "horizontal" =~ /#{ori}[orizontal]{,#{10 - ori.length}}/i then :H
          elsif "vertical" =~ /#{ori}[ertical]{,#{8 - ori.length}}/i then :V
          else raise InvalidOrientationArgument,
            "Invalid orientation \"#{ori}\":String"
          end
        when Symbol then ori_to_sym(ori.to_s)
        else raise InvalidOrientationArgument,
          "Invalid orientation type passed #{ori}:#{ori.class}"
      end
    end

    def self.format_pos(row, col, ori)
      Array.[](
        row.upcase.to_sym,
        col.ord - '0'.ord,
        ori[0].upcase.to_sym,
      )
    end
  end

  class Sector

    attr_accessor :ship

    def initialize(ship=nil)
      @ship = ship
    end

    def to_hash
      { :ship => @ship }
    end

    def ==(o)
      case o
        when Hash then to_hash == o
        else @ship == o.ship
      end
    end

    def to_s(empty=" ")
      @ship.nil? ? empty : @ship.to_s
    end
  end
end
