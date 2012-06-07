require 'spec_helper.rb'

module Rubaship
  describe Sector do
    before(:each) { @sector = Sector.new }

    describe "#==" do
      it "compares sectors based on shot and ship attributes" do
        @sector.ship = Ship.create(:D)
        Sector.new(Ship.create(:D)).should == @sector
      end
    end

    describe "#dup" do
      it "returns a deep copy of the sector" do
        lambda { @sector.dup.ship = Ship.create(:A) }.should_not change @sector, :ship
      end
    end

    describe "#ship=" do
      context "when it already contains a ship" do
        before(:each) do
          @sector = Sector.new
          @sector.ship = Ship.create(:A)
        end

        it "raises an OverlapShipError if it already contains a ship" do
          lambda { @sector.ship = Ship.create(:B) }.should raise_error(
            OverlapShipError,
            "Overlapping already positioned ship \"#{@sector.ship.name}\"."
          )
        end

        it "should not change the sector's ship" do
          @ship = Ship.create(:B)
          lambda {
            begin
              @sector.ship = @ship
            rescue OverlapShipError
            end
          }.should_not change(@sector, :ship)
        end
      end

      context "if it contains no ship" do
        before(:each) { @sector = Sector.new }

        it "adds the ship to the Sector object" do
          @ship = Ship.create(:B)
          lambda {
            @sector.ship = @ship
          }.should change(@sector, :ship).from(nil).to(@ship)
        end
      end
    end

    describe "#to_s" do
      it "returns a single space string when no ship exists" do
        @sector.to_s.should == " "
      end

      it "returns the character passed when no ship exists" do
        @sector.to_s("~").should == "~"
      end

      it "returns the ship's to_s method when there is a ship" do
        @sector.ship = Ship.create(:S)
        @sector.to_s("~").should == @sector.ship.to_s
      end
    end

    describe "#to_hash" do
      it "returns a hash representation of the sector" do
        @sector.ship = Ship.create(:B)
        @sector.to_hash.should == { :ship => @sector.ship }
      end
    end
  end
end
