require 'spec_helper.rb'

module Rubaship
  describe Player do
    before(:each) { @player = Player.new }

    describe "#grid" do
      it "returns a Grid object" do
        @player.grid.should be_a Grid
      end
    end

    describe "#place" do
      before(:each) { @player = Player.new }

      context "when passed a ship symbol" do
        it "parses the symbol to a ship object" do
          @ship = @player.ship(:B)
          @player.grid.should_receive(:add!).with(@ship, :D, 5, :V)
          @player.place(:B, :D, 5, :V)
        end
      end

      context "when passed a string position" do
        it "parses the string position using Grid#parse_pos" do
          @pos = Grid.parse_pos("D5:V")
          @player.grid.should_receive(:add!).with(@player.ship(:B), *@pos)
          @player.place(:B, *@pos)
        end
      end

      context "when passed an invalid ship Symbol" do
        it "raises an InvalidShipArgument" do
          lambda {
            @player.place(:T, :C, 5, :H)
          }.should raise_error(
            InvalidShipArgument,
            "Must be a valid ship symbol or name identifier."
          )
        end
      end

      context "when passed a Symbol matching an already placed ship" do
        it "raises an AlreadyPlacedShipError" do
          @player.place(:A, :H, 2, :H)
          lambda do
            @player.place(:A, :C, 2, :H)
          end.should raise_error(AlreadyPlacedShipError,
            "Cannot reposition the already placed ship aircraft carrier"
            )
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
  end
end
