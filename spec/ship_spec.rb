require 'spec_helper.rb'

module Rubaship
  shared_examples "a ship" do
    let(:ship) { described_class.new }

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
  end

  describe Ship do
    subject { Ship.new("destroyer", 3) }

    it { should respond_to :name }

    it { should respond_to :size }

    it { should respond_to :status }

    describe ".ships" do
      it "returns an array of 5 ships with one of each ship" do
        ships = [
          AircraftCarrier.new,
          Battleship.new,
          Submarine.new,
          Destroyer.new,
          PatrolBoat.new
        ]
        Ship.ships.should == ships
      end
    end

    describe ".create" do
      context "when passed a symbol" do
        it "retuns a ship object corresponding to the symbol passed" do
          Ship.create(:D).should == Destroyer.new
        end
      end
      context "when passed a string" do
        it "accepts the ship's name" do
          Ship.create("aircraft carrier").should == AircraftCarrier.new
        end
        it "accepts a string symbol" do
          Ship.create("B").should == Battleship.new
        end
      end
    end
  end

  describe AircraftCarrier do
    before(:all) do
      @ship = AircraftCarrier.new
      @name = "aircraft carrier"
      @size = 5
    end

    it_behaves_like "a ship"
  end

  describe Battleship do
    before(:all) do
      @ship = Battleship.new
      @name = "battleship"
      @size = 4
    end

    it_behaves_like "a ship"
  end

  describe Submarine do
    before(:all) do
      @ship = Submarine.new
      @name = "submarine"
      @size = 3
    end

    it_behaves_like "a ship"
  end

  describe Destroyer do
    before(:all) do
      @ship = Destroyer.new
      @name = "destroyer"
      @size = 3
    end

    it_behaves_like "a ship"
  end

  describe PatrolBoat do
    before(:all) do
      @ship = PatrolBoat.new
      @name = "patrol boat"
      @size = 2
    end

    it_behaves_like "a ship"
  end
end
