module Rubaship
  class InvalidShipArgument < ArgumentError
    def initialize(id)
      super("Must be a valid ship symbol or name identifier.")
    end
  end

  class InvalidPositionForShip < ArgumentError
    def initialize(ship, pos)
      super("The #{ship.name} does not fit inside the grid if placed in #{pos.to_s}.")
    end
  end

  class AlreadyPlacedShipError < StandardError
    def initialize(ship)
      super("Cannot reposition the already placed ship #{ship.name}")
    end
  end

  class OverlapShipError < StandardError
    def initialize(ship)
      super("Overlapping already positioned ship \"#{ship.name}\".")
    end
  end
end