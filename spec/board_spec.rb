require 'spec_helper.rb'

module Rubaship
  describe Board do
    before(:all) do
      @board = Board.new
    end

    describe ".parse_location" do
      before(:all) do
        @valid_location = "A7:H"
        @invalid_location = "A11:H"
      end

      context "when passed a valid location" do
        it "parses the location string passed to a hash of options" do
          Board.parse_location(@valid_location).should == { :row => :A, :col => 7, :ori => :H }
        end
      end
      context "when passed an invalid location" do
        it "returns nil" do
          Board.parse_location(@invalid_location).should be_nil
        end
      end
    end

    describe "#==" do
      context "when passed a Board object" do
        it "compares the two board object's arrays" do
          @board.should == Board.new
        end
      end
      context "when passed a hash" do
        it "compares the board object's to_hash method return with the hash passed" do
          @board.should == @board.to_hash
        end
      end
      context "when passed an array" do
        it "compares the board object's array with the array passed" do
          @board.should == @board.board
        end
      end
    end

    describe "#to_hash" do
      it "returns a hash representation of the board where keys map to row letters and values to arrays of row cells" do
        hash = Hash.new { |hash, key| hash[key.to_sym] = Array.new(10) { nil } }
        ("A".."J").each { |key| hash[key] }
        @board.to_hash.should == hash
      end
    end
  end
end
