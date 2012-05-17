module Rubaship
  class Ship

    TOTAL_SHIPS = 5

    attr_reader :name, :size, :status, :position

    def initialize(name, size, status=size)
      @name, @size, @status = name, size, status
      @position, @placed = nil, false
    end

    def ==(o)
      return false unless o.is_a? Ship
      @name == o.name &&
      @size == o.size &&
      @status == o.status
    end

    def placed?
      @placed
    end

    def to_a
      Array.new(@size) { self }
    end

    def to_s
      @name[0].upcase
    end

    def position=(pos)
      @position = pos
      @placed = true
    end
  end

  class AircraftCarrier < Ship

    INDEX = 0

    def initialize
      super("aircraft carrier", 5)
    end
  end

  class Battleship < Ship

    INDEX = 1

    def initialize
      super("battleship", 4)
    end
  end

  class Submarine < Ship

    INDEX = 2

    def initialize
      super("submarine", 3)
    end
  end

  class Destroyer < Ship

    INDEX = 3

    def initialize
      super("destroyer", 3)
    end
  end

  class PatrolBoat < Ship

    INDEX = 4

    def initialize
      super("patrol boat", 2)
    end
  end

  class Ship
    def self.ships
      ary = []
      ary.insert(AircraftCarrier::INDEX, AircraftCarrier.new)
      ary.insert(Battleship::INDEX, Battleship.new)
      ary.insert(Submarine::INDEX, Submarine.new)
      ary.insert(Destroyer::INDEX, Destroyer.new)
      ary.insert(PatrolBoat::INDEX, PatrolBoat.new)
    end

    def self.create(ship)
      ships[index(ship)]
    end

    def self.index(ship)
      return ship >= 0 && ship < TOTAL_SHIPS ? ship : TOTAL_SHIPS if ship.is_a?(Fixnum)
      case ship
      when :A, 'A', /\Aaircraft carrier\z/i then AircraftCarrier::INDEX
      when :B, 'B', /\Abattleship\z/i then Battleship::INDEX
      when :S, 'S', /\Asubmarine\z/i then Submarine::INDEX
      when :D, 'D', /\Adestroyer\z/i then Destroyer::INDEX
      when :P, 'P', /\Apatrol boat\z/i then PatrolBoat::INDEX
      else TOTAL_SHIPS
      end
    end
  end
end
