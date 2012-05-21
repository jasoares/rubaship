module Rubaship

  class InvalidOrientationArgument < ArgumentError; end

  class Board

    ROWS = ("A".."J").to_a

    POSITION_REGEXP = /^(?<anchor>[A-Z0-9]{2,3}):(?<orientation>[a-z]{1,10})$/i
    ANCHOR_REGEXP = /^(?:(?<row>[A-J])(?<col>([1-9])|10)|\g<col>\g<row>)$/i
    ORIENT_REGEXP = /^(?<ori>
      h(o(r(i(z(o(n(t(a(l)?)?)?)?)?)?)?)?)? |
      v(e(r(t(i(c(a(l)?)?)?)?)?)?)?)$/ix

    attr_reader :board

    def initialize
      @board = Array.new(10) { Array.new(10) { Sector.new } }
    end

    def ==(o)
      return case o
        when Hash  then to_hash == o
        when Array then @board == o
        when Board then @board == o.board
      end
    end

    def [](index)
      @board[Board.row_to_idx(index)]
    end

    def add!(ship, pos_row, col=nil, ori=:H)
      if col.nil?
        pos_row, col, ori = Board.parse_pos(pos_row) if pos_row.is_a? String
        pos_row, col, ori = pos_row if pos_row.is_a? Array
      end

      row = Board.row_to_idx(pos_row)
      col = Board.col_to_idx(col)
      ori = Board.ori_to_sym(ori)

      case ori
        when :H
          @board[row][col..col + ship.size - 1].each do |sector|
            sector.ship = ship
          end
        when :V
          @board[row..row + ship.size - 1].each do |row|
            row[col].ship = ship
          end
      end
      @board
    end

    def to_hash
      @board.each_with_index.inject({}) do |row_hash, (row, i)|
        row_hash[ROWS[i].to_sym] = row.collect { |sector| sector.to_hash }
        row_hash
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
        else raise "invalid row or range passed #{row}"
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
  end
end
