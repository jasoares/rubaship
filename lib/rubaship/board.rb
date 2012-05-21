module Rubaship
  class Board

    ROWS = ("A".."J").to_a

    POSITION_REGEXP = /^(?<anchor>[A-Z0-9]{2,3}):(?<orientation>[a-z]{1,10})$/i
    ANCHOR_REGEXP = /^(?:(?<row>[A-J])(?<col>([1-9])|10)|\g<col>\g<row>)$/i
    ORIENT_REGEXP = /^(?<ori>h(o(r(i(z(o(n(t(a(l)?)?)?)?)?)?)?)?)?|v(e(r(t(i(c(a(l)?)?)?)?)?)?)?)$/i

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
      @board[Board.row_to_index(index)]
    end

    def add!(ship, pos_row, col=nil, ori=:H)
      pos_row, col, ori = Board.parse_pos(pos_row) if pos_row.is_a? String and col.nil?
      pos_row, col, ori = pos_row if pos_row.is_a? Array

      row = Board.row_to_index(pos_row)
      col = Board.col_to_index(col)
      ori = Board.orient_to_symbol(ori)

      case ori
        when :H
          @board[row][col..col + ship.size - 1].each { |sector| sector.ship = ship }
        when :V
          @board[row..row + ship.size - 1].each { |row| row[col].ship = ship }
        else raise "No valid orientation error!"
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
        pos_to_simple(anchor[1], anchor[2], orient[1])
      end
    end

    def self.row_to_index(row)
      return case row
        when Fixnum then row
        when String then ROWS.index(row.upcase)
        when Symbol then row_to_index(row.to_s)
        when Range
          if row.first.is_a? Fixnum
            row
          else
            Range.new(row_to_index(row.min), row_to_index(row.max))
          end
        else raise "invalid row or range passed #{row}"
      end
    end

    def self.col_to_index(col, array_index=true)
      return case col
        when Fixnum then array_index ? col - 1 : col
        when String then col_to_index(col.ord - '0'.ord, array_index)
        when Symbol then col_to_index(col.to_s, array_index)
        when Range
          if col.first.is_a? Fixnum
            Range.new((col_to_index(col.min, array_index)), col_to_index(col.max, array_index))
          else
            Range.new(col_to_index(col.min, array_index), col_to_index(col.max, array_index))
          end
        else raise "invalid column or range passed #{col}"
      end
    end

    def self.orient_to_symbol(ori)
      return case ori
        when String
          if "horizontal" =~ /#{ori}[orizontal]{,9}/i then :H
          elsif "vertical" =~ /#{ori}[ertical]{,7}/i then :V
          else nil end
        when Symbol then orient_to_symbol(ori.to_s)
        else raise "invalid orientation passed #{ori}"
      end
    end

    def self.pos_to_simple(row, col, ori)
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
