module Rubaship

  class InvalidRowArgument < ArgumentError
    def initialize(row)
      super("Invalid row or range type passed #{row}:#{row.class}")
    end
  end

  class InvalidColumnArgument < ArgumentError
    def initialize(col)
      super("Invalid column or range type passed #{col}:#{col.class}")
    end
  end

  class InvalidOrientationArgument < ArgumentError
    def initialize(ori)
      super("Invalid orientation type passed #{ori}:#{ori.class}")
    end
  end

  class InvalidShipArgument < ArgumentError
    def initialize(ship)
      if !ship.is_a? Ship
        super("Must be a Ship object and it was #{ship}:#{ship.class}")
      elsif ship.placed?
        super("The ship is already placed.")
      end
    end
  end

  class InvalidShipIdentifier < ArgumentError
    def initialize(id)
      super("Must be a valid ship symbol or name.")
    end
  end

  class InvalidShipPosition < StandardError
    def initialize(ship=nil)
      if ship.nil?
        super("Ship does not fit inside the board if placed in that position.")
      else
        super("Overlapping already positioned ship \"#{ship.name}\".")
      end
    end
  end
end