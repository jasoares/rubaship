require 'spec_helper.rb'

module Rubaship
  describe Player do
    before(:all) do
      @player = Player.new
    end

    describe "#board" do
      it "returns a Board object" do
        @player.board.should be_a Board
      end
    end

    describe "#place" do
      before(:each) do
        @player = Player.new
        @board = @player.board
      end

      it "tries to add a ship to the board" do
        pos = [ :D, 5, :V ]
        @board.should_receive(:add!).with(@player.ship(:B), pos)
        @player.place(:B, pos)
      end
    end

    describe "#ships" do
      it "returns an array" do
        @player.ships.should be_an Array
      end

      it "should have 5 ships" do
        @player.should have_exactly(5).ships
      end

      it "includes one of each ship" do
        Ship.ships.each { |ship| @player.ships.should include ship }
      end

      it "orders the array of ships according to Ship::INDEX" do
        @player.ships.each_with_index do |ship, index|
          index.should be ship.class::INDEX unless ship.nil?
        end
      end
    end

    describe "#ship" do
      context "when passed a Fixnum index" do
        it "is equivalent to using @player.ships[index]" do
          @player.ship(0).should == @player.ships[0]
        end
      end
      context "when passed a Symbol" do
        it "is equivalent to using @player.ships[Ship.index(symbol)]" do
          @player.ship(:B).should == @player.ships[Ship.index(:B)]
        end
      end
      context "when passed a string" do
        context "when passed a string with the ship's initial letter" do
          it "is equivalent to using @player.ships[Ship.index(initial)]" do
            @player.ship("A").should == @player.ships[Ship.index("A")]
          end
        end
        context "when passed a string with the ship's name" do
          it "is equivalent to using @player.ships[Ship.index(name)]" do
            @player.ship("Submarine").should == @player.ships[Ship.index("Submarine")]
          end
        end
      end
    end
  end
end
