module Rubaship
  class Player

    attr_reader :ships, :grid

    def initialize
      @ships = Ship.ships
      @grid = Grid::Grid.new
    end

    def ship(type)
      return @ships[type] if type.is_a? Fixnum
      @ships[Ship.index(type)]
    end

    def place(ship, *pos)
      raise InvalidShipArgument.new(ship) if (ship = self.ship(ship)).nil?
      raise AlreadyPlacedShipError.new(ship) if ship.placed?
      ship.position = @grid.add!(ship, *pos).to_a
    end
  end
end
