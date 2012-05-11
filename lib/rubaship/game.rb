module Rubaship
  class Game
    attr_reader :player

    def initialize
      @player = Player.new
    end

  end
end