module Rubaship

  class InvalidRowArgument < ArgumentError
    def initialize(row)
      super("Invalid row or range type passed #{row}:#{row.class}")
    end
  end

  class InvalidColArgument < ArgumentError
    def initialize(col)
      super("Invalid column or range type passed #{col}:#{col.class}")
    end
  end

  class InvalidOriArgument < ArgumentError
    def initialize(ori)
      super("Invalid orientation type passed #{ori}:#{ori.class}")
    end
  end

  class InvalidShipArgument < ArgumentError
    def initialize(id)
      super("Must be a valid ship symbol or name identifier.")
    end
  end

  class InvalidPositionArgument < ArgumentError
    def initialize
      super("Either row or col must be a Range matching the orientation argument if any.")
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