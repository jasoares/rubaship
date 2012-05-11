require 'spec_helper.rb'

module Rubaship
  describe Game do
    before(:all) do
      @game = Game.new
    end

    describe "#player" do
      before(:all) do
        @player = @game.player
      end

      it "should return a player" do
        @player.should be_a_kind_of Player
      end
    end

  end
end