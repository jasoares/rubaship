require 'spec_helper.rb'

module Rubaship

  shared_examples "a ship" do
    before(:all) do
      @ship = Ship.create(@name)
    end

    it { should respond_to :name }

    it { should respond_to :placed? }

    it { should respond_to :size }

    it { should respond_to :status }

    describe "::INDEX" do
      it "returns the ship's ordering index" do
        described_class::INDEX.should be @index
      end
    end

    describe "#name" do
      it "returns the ship's name" do
        @ship.name.should == @name
      end
    end

    describe "#size" do
      it "returns the ship's size" do
        @ship.size.should be @size
      end
    end

    describe "#status" do
      it "should be equal to its size right after creation" do
        @ship.status.should be @size
      end
    end

    describe "#placed?" do
      it "returns false if the ship has not been placed yet" do
        @ship.placed?.should be false
      end

      it "returns true after the ship has been placed" do
        @player = Player.new
        @player.place(@name, Board.parse_pos("3d:h"))
        @player.ship(@name).placed?.should be true
      end
    end

    describe "#position" do
      it "returns nil when if the ship has not been placed" do
        @ship.position.should be_nil
      end

      context "when the ship is already placed on a board" do
        before(:all) do
          @player = Player.new
          @ship = @player.ship(@name)
          @pos = [ :C, 3, :V ]
          @player.place(@ship, @pos)
        end

        it "should return its position represented by an array" do
          @ship.position.should be_an Array
        end

        it "should contain the position of the ship" do
          @ship.position.should be == @pos
        end
      end
    end

    describe "#to_a" do
      it "returns an array representation of the ship with length equal to ship.size" do
        @ship.to_a.should == Array.new(@ship.size) { @ship }
      end
    end

    describe "#to_s" do
      it "returns a symbol representation of the, as shown on the board" do
        @ship.to_s.should == @ship.name[0].upcase
      end
    end
  end

  describe Ship do

    describe ".ships" do
      it "should be an array" do
        Ship.ships.should be_an Array
      end

      it "should have 5 ships" do
        Ship.ships.should have(5).ships
      end

      it "should be ordered by Ship::INDEX" do
        Ship.ships.each_with_index do |ship, index|
          index.should be ship.class::INDEX unless ship.nil?
        end
      end
    end

    describe ".create" do
      it "creates a new ship object based on the argument passed" do
        Ship.create(:A).should == AircraftCarrier.new
      end

      it "matches Ship::INDEX when a Fixnum is passed" do
        Ship.create(4).should == PatrolBoat.new
      end

      it "matches a ship using Ship.index when a Symbol is passed" do
        Ship.create(:D).should == Destroyer.new
      end

      context "when passed a string" do
        it "uses Ship.index to match a ship when a name is passed" do
          Ship.create("aircraft carrier").should == AircraftCarrier.new
        end

        it "uses Ship.index to match a ship when a ship's name initial is passed" do
          Ship.create("B").should == Battleship.new
        end
      end

      context "when passed an invalid ship identifier. See Ship.index" do
        it "returns nil when passed a Fixnum" do
          Ship.create(5).should be nil
        end

        it "returns nil when passed a String" do
          Ship.create("cruiser").should be nil
        end

        it "returns nil when passed a Symbol" do
          Ship.create(:F).should be nil
        end
      end
    end

    describe ".index" do
      it "returns the ship's index that matches the Symbol name passed" do
        Ship.index(:patrol_boat) == PatrolBoat::INDEX
      end

      it "returns the ship's index that matches the Symbol letter passed" do
        Ship.index(:D).should == Destroyer::INDEX
      end

      it "returns the ship's index that matches the String name passed" do
        Ship.index("aircraft carrier").should == AircraftCarrier::INDEX
      end

      it "retuns the ship's index that matches the String letter passed" do
        Ship.index("B").should be 1
      end

      it "returns the aircraft carrier index when passed the small form \"carrier\"" do
        Ship.index("carrier").should == AircraftCarrier::INDEX
      end

      it "returns the argument unchanged when passed a Fixnum" do
        Ship.index(3).should be 3
      end

      it "returns Ship::TOTAL_SHIPS when passed any other invalid identifier" do
        Ship.index(6).should be 5
      end
    end
  end

  describe AircraftCarrier do
    before(:all) do
      @name = "aircraft carrier"
      @size = 5
      @index = 0
    end

    it_behaves_like "a ship"
  end

  describe Battleship do
    before(:all) do
      @name = "battleship"
      @size = 4
      @index = 1
    end

    it_behaves_like "a ship"
  end

  describe Destroyer do
    before(:all) do
      @name = "destroyer"
      @size = 3
      @index = 2
    end

    it_behaves_like "a ship"
  end

  describe Submarine do
    before(:all) do
      @name = "submarine"
      @size = 3
      @index = 3
    end

    it_behaves_like "a ship"
  end

  describe PatrolBoat do
    before(:all) do
      @name = "patrol boat"
      @size = 2
      @index = 4
    end

    it_behaves_like "a ship"
  end
end
