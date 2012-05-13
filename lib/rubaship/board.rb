module Rubaship
  class Board

    ROWS = ("A".."J").to_a
    COLS = (1..10).to_a

    attr_reader :board

    def initialize
      @board = Hash.new { |board, row| board[row] = Array.new(10) { nil } }
      ("A".."J").each { |row| @board[row] }
    end

    def ==(o)
      @board == o
    end

    def to_hash
      @board
    end
  end
end
