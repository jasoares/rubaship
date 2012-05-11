module Rubaship
  class Player

    attr_reader :ships

    def initialize
      @ships = Ship.ships
    end
  end
end