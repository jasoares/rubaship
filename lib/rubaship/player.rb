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

    def place(ship, pos_row, col=nil, ori=nil)
      if (ship = self.ship(ship)).nil?
        raise InvalidShipArgument, "Must be a valid ship symbol or name."
      end
      if ship.placed?
        raise InvalidShipArgument, "The ship is already placed."
      end
      if col.nil?
        pos_row, col, ori = Board.parse_pos(pos_row) if pos_row.is_a? String
        pos_row, col, ori = pos_row if pos_row.is_a? Array
      elsif ori.nil?
        raise InvalidShipPosition unless pos_row.is_a? Range or col.is_a? Range
      end
      @board.add!(ship, pos_row, col, ori)
      ship.position = [pos_row, col, ori]
    end
  end
end