module Rubaship
  class Board

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
  end
end
