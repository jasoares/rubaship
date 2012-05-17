module Rubaship
  class Player

    attr_reader :ships, :board

    def initialize
      @ships = Ship.ships
      @board = Board.new
    end

    def ship(type)
      return @ships[type] if type.is_a? Fixnum
      @ships[Ship.index(type)]
    end

    def place(ship, pos)
      ship = self.ship(ship) unless ship.is_a? Ship
      ship.position = pos if @board.add!(ship, pos)
    end
  end
end