module Rubaship
  class Player

    attr_reader :ships, :board

    def initialize
      @ships = Ship.ships
      @board = Board.new
    end
  end
end