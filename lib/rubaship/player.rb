module Rubaship
  class Player

    attr_reader :ships, :grid

    def initialize
      @ships = Ship.ships
      @grid = Grid.new
    end

    def ship(type)
      return @ships[type] if type.is_a? Fixnum
      @ships[Ship.index(type)]
    end

    def place(ship, *pos)
      raise InvalidShipArgument.new(ship) if (ship = self.ship(ship)).nil?
      raise AlreadyPlacedShipError.new(ship) if ship.placed?
      pos = pos.is_a?(Pos) ? pos : Pos.new(*pos)
      @grid.add!(ship, *pos)
      ship.position = *pos
    end
  end
end
