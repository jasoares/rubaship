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
      if o.is_a? Hash then to_hash == o
      elsif o.is_a? Array then @board == o
      elsif o.is_a? Board then @board == o.board end
    end

    def to_hash
      @board.each_with_index.inject({}) do |hash, (row, i)|
        hash[('A'.ord + i).chr.to_sym] = row; hash
      end
    end

    def self.parse_location(location)
      r = LOCATION_REGEXP.match(location)
      return {
        :row => r[:row].upcase.to_sym,
        :col => r[:col].ord - '0'.ord,
        :ori => r[:ori][0].upcase.to_sym
      } unless r.nil?
    end
  end
end
