module Rubaship
  class Board

    LOCATION_REGEXP = %r{
      ^(?:
        (?<row> [A-J] )
        (?<col> ([1-9]) | 10 ) |
        \g<col> \g<row>
      ) :
      (?<ori>
        h(o(r(i(z(o(n(t(a(l)?)?)?)?)?)?)?)?)? |
        v(e(r(t(i(c(a(l)?)?)?)?)?)?)?
      )$
    }ix

    attr_reader :board

    def initialize
      @board = Array.new(10) { Array.new(10) { nil } }
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

    def add!(ship, p)
      row = Board.row_to_index(p[:row])
      col = p[:col]
      case p[:ori]
      when :H
        @board[row][col..col + ship.size - 1] = ship.to_a
      when :V
        @board[row..row + ship.size - 1].each { |row| row[col] = ship }
      end
    end

    def to_hash
      @board.each_with_index.inject({}) do |hash, (row, i)|
        hash[('A'.ord + i).chr.to_sym] = row; hash
      end
    end

    def self.parse_pos(pos)
      r = LOCATION_REGEXP.match(pos)
      return {
        :row => r[:row].upcase.to_sym,
        :col => r[:col].ord - '0'.ord - 1,
        :ori => r[:ori][0].upcase.to_sym
      } unless r.nil?
    end

    def self.row_to_index(row)
      return case row
        when String then row[0].upcase.ord - 'A'.ord
        when Symbol then self.row_to_index(row.to_s)
        when Fixnum then row
        when Range
          if row.first.is_a? Fixnum then row
          else Range.new(row_to_index(row.min), row_to_index(row.max)) end
        else row
      end
    end
  end
end
