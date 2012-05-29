require 'spec_helper.rb'

module Rubaship
  describe Game do
    before(:all) { @game = Game.new }

    describe "#player" do
      it "should return a player" do
        @player = @game.player
        @player.should be_a_kind_of Player
      end
    end
  end
end
