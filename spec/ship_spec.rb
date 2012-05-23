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
      context "when just created" do
        it "should be equal to its size" do
          @ship.status.should be @size
        end
      end
    end

    describe "#placed?" do
      context "when the ship has just been created and have not been placed yet" do
        it "returns false" do
          @ship.placed?.should be false
        end
      end
      context "when the ship has been already placed on the board" do
        it "returns true" do
          @player = Player.new
          @player.place(@name, Board.parse_pos("3d:h"))
          @player.ship(@name).placed?.should be true
        end
      end
    end

    describe "#position" do
      context "when the ship has not been placed on a board yet" do
        it "returns nil" do
          @ship.position.should be_nil
        end
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
      context "when passed a Fixnum" do
        it "returns a new ship object which type matches the Ship::INDEX to the argument passed" do
          Ship.create(4).should == PatrolBoat.new
        end
      end
      context "when passed a symbol" do
        it "uses Ship.index to return a ship object corresponding to the symbol passed" do
          Ship.create(:D).should == Destroyer.new
        end
      end
      context "when passed a string" do
        context "and it contains a ship's name" do
          it "uses Ship.index to return a ship object corresponding to the ship's name" do
            Ship.create("aircraft carrier").should == AircraftCarrier.new
          end
        end
        context "and it contains a ship's name initial" do
          it "uses Ship.index to return a ship object corresponding to the ship's name initial" do
            Ship.create("B").should == Battleship.new
          end
        end
      end
      context "when passed an invalid ship identifier. See Ship.index" do
        context "and it is a Fixnum" do
          it "returns nil" do
            Ship.create(5).should be nil
          end
        end
        context "and it is a String" do
          it "returns nil" do
            Ship.create("cruiser").should be nil
          end
        end
        context "and it is a Symbol" do
          it "returns nil" do
            Ship.create(:F).should be nil
          end
        end
      end
    end

    describe ".index" do
      context "when passed a Symbol" do
        context "and it contains a ship's initial letter" do
          it "retuns the ship's array index corresponding to that ship" do
            Ship.index(:D).should == Destroyer::INDEX
          end
        end
        context "and it contains a ship's name with spaces replaced by underscores" do
          it "returns that ship's array index" do
            Ship.index(:patrol_boat) == PatrolBoat::INDEX
          end
        end
      end
      context "when passed one of the following valid ship identifiers as a string:" do
        context "the ship's name, case insensitive and space separated" do
          it "retuns the corresponding ship's array index" do
            Ship.index("aircraft carrier").should == AircraftCarrier::INDEX
          end
        end
        context "when passed the identifier \"carrier\" as the aircraft carrier" do
          it "returns the expected ship, this only works for carriers and boats" do
            Ship.index("carrier").should == AircraftCarrier::INDEX
          end
        end
        context "the ship's name initial letter, case insensitive" do
          it "retuns the corresponding ship's array index" do
            Ship.index("B").should be 1
          end
        end
      end
      context "when passed a Fixnum index" do
        context "and it is valid" do
          it "returns the argument passed" do
            Ship.index(3).should be 3
          end
        end
        context "and it is invalid" do
          it "returns the Ship::TOTAL_SHIPS constant" do
            Ship.index(7).should be 5
          end
        end
      end
      context "when the argument passed is an invalid ship index or identifier" do
        it "returns Ship::TOTAL_SHIPS" do
          Ship.index(6).should be 5
        end
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
