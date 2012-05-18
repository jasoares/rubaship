require 'spec_helper.rb'

module Rubaship
  describe Board do
    describe ".parse_pos" do
      before(:all) do
        @valid_pos = "A7:H"
        @invalid_pos = "A11:H"
      end

      context "when passed a valid position" do
        it "parses the position string passed to a hash of options" do
          Board.parse_pos(@valid_pos).should == { :row => :A, :col => 6, :ori => :H }
        end
      end
      context "when passed an invalid position" do
        it "returns nil" do
          Board.parse_pos(@invalid_pos).should be_nil
        end
      end
    end

    describe ".row_to_index" do
      context "when passed a string with a row letter" do
        it "returns its equivalent index to the board" do
          Board.row_to_index("C").should be 2
        end
      end
      context "when passed a row letter symbol" do
        it "returns its equivalent index to the board" do
          Board.row_to_index(:D).should be 3
        end
      end
      context "when passed a Fixnum" do
        it "returns the argument passed unchanged" do
          Board.row_to_index(3).should be 3
        end
      end
      context "when passed a Range" do
        context "and it is a range of Strings" do
          it "converts the range to a Fixnum range" do
            Board.row_to_index("B".."D").should == (1..3)
          end
        end
        context "and it is a range of Symbols" do
          it "converts the range to a Fixnum range" do
            Board.row_to_index(:C..:E).should == (2..4)
          end
        end
        context "and it is a range of Fixnums" do
          it "returns the argument passed unchanged" do
            Board.row_to_index(3..5).should == (3..5)
          end
        end
      end
    end

    describe "#==" do
      before(:all) do
        @board = Board.new
        @board.add!(Ship.create(:D), Board.parse_pos("G3:H"))
      end
      context "when passed a Board object" do
        it "compares the two board object's arrays" do
          board = Board.new
          board.add!(Ship.create(:D), Board.parse_pos("G3:H"))
          @board.should == board
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

    describe "#[]" do
      before(:all) do
        @board = Board.new
        @board.add!(Ship.create(:D), Board.parse_pos("C2:H"))
        @board.add!(Ship.create(:S), Board.parse_pos("C1:V"))
      end
      context "when passed an integer" do
        it "returns the row from board with that index" do
          @board[0].should == @board.board[0]
        end
      end
      context "when passed a symbol" do
        it "returns the indexed row equivalent to that key symbol" do
          @board[:C].should == @board.board[2]
        end
      end
      context "when passed a string symbol" do
        it "returns the indexed row equivalent to that string symbol" do
          @board["J"].should == @board.board[9]
        end
      end
    end

    describe "#add!" do
      before(:each) do
        @board = Board.new
      end
      context "when passed a valid anchor" do
        context "with horizontal orientation" do
          it "updates the row equivalent to the index or symbol passed to reflect the ship position" do
            @ship = Ship.create(:S)
            @board.add!(@ship, { :row => :D, :col => 2, :ori => :H })
            @board[:D][2..(2 + @ship.size - 1)].should == @ship.to_a
          end
        end
        context "with vertical orientation" do
          it "updates the column equivalent to the index passed to reflect the ship position" do
            @ship = Ship.create(:A)
            @board.add!(@ship, { :row => :B, :col => 8, :ori => :V })
            @board[:B..:F].collect { |row| row[8] }.should == @ship.to_a
          end
        end
      end
    end

    describe "#to_hash" do
      before(:each) do
        @board = Board.new
      end
      it "returns a hash representation of the board where keys map to row letters and values to arrays of row cells" do
        hash = Hash.new { |hash, key| hash[key.to_sym] = Array.new(10) { nil } }
        ("A".."J").each { |key| hash[key] }
        @board.to_hash.should == hash
      end
    end
  end
end
