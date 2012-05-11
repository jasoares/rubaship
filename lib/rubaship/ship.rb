module Rubaship
  class Ship

    attr_reader :name, :size, :status

    def initialize(name, size, status=size)
      @name, @size, @status = name, size, status
    end

    def ==(o)
      return false unless o.is_a? Ship
      @name == o.name &&
      @size == o.size &&
      @status == o.status
    end
  end

  class AircraftCarrier < Ship
    def initialize
      super("aircraft carrier", 5)
    end
  end

  class Battleship < Ship
    def initialize
      super("battleship", 4)
    end
  end

  class Submarine < Ship
    def initialize
      super("submarine", 3)
    end
  end

  class Destroyer < Ship
    def initialize
      super("destroyer", 3)
    end
  end

  class PatrolBoat < Ship
    def initialize
      super("patrol boat", 2)
    end
  end

  class Ship
    def self.ships
      [
        AircraftCarrier.new,
        Battleship.new,
        Submarine.new,
        Destroyer.new,
        PatrolBoat.new
      ]
    end
  end
end