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

    def place(ship, pos_row, col=nil, ori=nil)
      raise InvalidShipArgument.new(ship) if (ship = self.ship(ship)).nil?
      raise AlreadyPlacedShipError.new(ship) if ship.placed?
      if !col
        pos_row, col, ori = Pos.parse(pos_row) if pos_row.is_a?(String)
      elsif !ori
        raise InvalidPositionArgument unless pos_row.is_a? Range or col.is_a? Range
      end
      @grid.add!(ship, pos_row, col, ori)
      ship.position = [pos_row, col, ori]
    end
  end
end
