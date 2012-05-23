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

  class Destroyer < Ship

    INDEX = 2

    def initialize
      super("destroyer", 3)
    end
  end

  class Submarine < Ship

    INDEX = 3

    def initialize
      super("submarine", 3)
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
      ary = Array.new(TOTAL_SHIPS)
      ary[AircraftCarrier::INDEX] = AircraftCarrier.new
      ary[Battleship::INDEX]      = Battleship.new
      ary[Destroyer::INDEX]       = Destroyer.new
      ary[Submarine::INDEX]       = Submarine.new
      ary[PatrolBoat::INDEX]      = PatrolBoat.new
      ary
    end

    def self.create(ship)
      ships[index(ship)]
    end

    def self.index(ship)
      case ship
        when :A, 'A', /\Aaircraft carrier\z/i; AircraftCarrier::INDEX
        when :B, 'B', /\Abattleship\z/i      ; Battleship::INDEX
        when :D, 'D', /\Adestroyer\z/i       ; Destroyer::INDEX
        when :S, 'S', /\Asubmarine\z/i       ; Submarine::INDEX
        when :P, 'P', /\Apatrol boat\z/i     ; PatrolBoat::INDEX
        when Fixnum; (ship >= 0 && ship < TOTAL_SHIPS) ? ship : TOTAL_SHIPS
        else TOTAL_SHIPS
      end
    end
  end
end
