require 'spec_helper.rb'

module Rubaship
  describe Player do
    before(:all) do
      @player = Player.new
    end

    describe "#ships" do
      it "returns an array" do
        @player.ships.should be_an Array
      end

      it "should have 5 ships" do
        @player.should have_exactly(5).ships
      end

      it "should include one of each ship" do
        @player.ships.should == Ship.ships
      end
    end

    describe "#board" do
      it "returns a Board object" do
        @player.board.should be_a Board
      end
    end
  end
end
