require 'spec_helper.rb'

module Rubaship
  describe Board do
    before(:all) do
      @board = Board.new
      @hash = @board.to_hash
    end

    describe ".ROWS" do
      it "returns the array of acceptable rows" do
        Board::ROWS.should == ("A".."J").to_a
      end
    end

    describe ".COLS" do
      it "returns the array of acceptable columns" do
        Board::COLS.should == (1..10).to_a
      end
    end

    describe "#==" do
      context "when passed a Board object" do
        it "compares the two board objects based on its to_hash methods" do
          @board.should == Board.new
        end
      end
      context "when passed a hash" do
        it "compares the board object's to_hash method return with the hash passed" do
          @board.should == @hash
        end
      end
    end

    describe "#to_hash" do
      it "returns a hash representation of the board" do
        hash = Hash.new { |hash, key| hash[key] = Array.new(10) { nil } }
        ("A".."J").each { |key| hash[key] }
        @board.to_hash.should == hash
      end
    end
  end
end
