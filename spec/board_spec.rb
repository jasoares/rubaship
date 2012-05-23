require 'spec_helper.rb'

module Rubaship
  describe Board do
    describe Board::ROWS do
      it "returns the array of valid board rows" do
        Board::ROWS.should == %w{ A B C D E F G H I J }
      end
    end

    describe ".parse_pos" do
      before(:all) do
        @valid_pos = "A7:H"
        @invalid_pos = "A11:H"
      end

      context "when passed a valid position" do
        it "parses the position string passed to a hash of options" do
          Board.parse_pos(@valid_pos).should ==  [:A, 7, :H]
        end
      end
      context "when passed an invalid position" do
        it "returns nil" do
          Board.parse_pos(@invalid_pos).should be_nil
        end
      end
    end

    describe ".row_to_idx" do
      context "when passed a string with a row letter" do
        it "returns its equivalent index to the board" do
          Board.row_to_idx("C").should be 2
        end
      end
      context "when passed a row letter symbol" do
        it "returns its equivalent index to the board" do
          Board.row_to_idx(:D).should be 3
        end
      end
      context "when passed a Range" do
        context "and it is a range of Strings" do
          it "converts the range to a Fixnum range" do
            Board.row_to_idx("B".."D").should == (1..3)
          end
        end
        context "and it is a range of Symbols" do
          it "converts the range to a Fixnum range" do
            Board.row_to_idx(:C..:E).should == (2..4)
          end
        end
        context "and it is a range of Fixnums" do
          it "returns the argument passed unchanged" do
            Board.row_to_idx(3..5).should == (3..5)
          end
        end
      end
      context "when passed any other type" do
        it "raises an exception" do
          lambda { Board.row_to_idx([2]) }.should raise_error(InvalidRowArgument)
        end
      end
    end

    describe ".col_to_idx" do
      context "when no array_index argument is passed or its value is true(default)" do
        context "and passed a string with a number" do
          it "returns the index of the column passed" do
            Board.col_to_idx("3", true).should be 2
          end
        end
        context "and passed a Fixnum with column number" do
          it "returns the index of the column passed" do
            Board.col_to_idx(5).should be 4
          end
        end
        context "and passed a range of columns" do
          it "returns the range with its max and min decreased by 1" do
            Board.col_to_idx(3..6).should == (2..5)
          end
        end
        context "and passed an invalid column type" do
          it "raises an exception" do
            lambda { Board.col_to_idx(:"2") }.should raise_error(InvalidColumnArgument)
          end
        end
      end
      context "when the optional array_index argument is passed as false" do
        context "and is passed a string with a number" do
          it "returns the column number of the column passed corresponding to the board" do
            Board.col_to_idx("4", false).should be 4
          end
        end
        context "and is passed a Fixnum with column number" do
          it "returns the column number of the column number passed" do
            Board.col_to_idx(5, false).should be 5
          end
        end
        context "and is passed a Range of String numbers" do
          it "returns the column range corresponding to the board column numbers passed" do
            Board.col_to_idx("4".."7", false).should == (4..7)
          end
        end
        context "and passed an invalid column type" do
          it "raises an exception" do
            lambda { Board.col_to_idx(:"2") }.should raise_error(InvalidColumnArgument)
          end
        end
      end
    end

    describe ".ori_to_sym" do
      context "when passed a String" do
        context "and it contains a valid orientation" do
          it "accepts the full word 'horizontal' or 'vertical'" do
            Board.ori_to_sym("horizontal").should be :H
          end
          it "accepts a partial word like 'horiz' or 'vertic'" do
            Board.ori_to_sym("horiz").should be :H
          end
          it "accepts the initial letter of the work like 'h' or 'v'" do
            Board.ori_to_sym("v").should be :V
          end
        end
        context "and it contains an invalid orientation" do
          it "raises an InvalidOrientationArgument" do
            lambda { Board.ori_to_sym("vr") }.should raise_error(InvalidOrientationArgument)
          end
        end
      end
      context "when passed a Symbol with a valid orientation" do
        it "accepts the full word like :HORIZONTAL or :vertical" do
          Board.ori_to_sym(:HORIZONTAL).should be :H
        end
        it "accepts a partial word like :Horiz or :vertic" do
          Board.ori_to_sym(:Horiz).should be :H
        end
        it "accepts the initial letter of the work like :h or :V" do
          Board.ori_to_sym(:V).should be :V
        end
        context "and it contains an invalid orientation" do
          it "raises an InvalidOrientationArgument" do
            lambda { Board.ori_to_sym(:hr) }.should raise_error(InvalidOrientationArgument)
          end
        end
      end
      context "when passed an invalid type" do
        it "raises an InvalidOrientationArgument" do
          lambda { Board.ori_to_sym(4) }.should raise_error(InvalidOrientationArgument)
        end
      end
    end

    describe "#==" do
      before(:all) do
        @board = Board.new
        @board.add!(Ship.create(:D), "G3:H")
      end
      context "when passed a Board object" do
        it "compares the two board object's arrays" do
          board = Board.new
          board.add!(Ship.create(:D), :G, 3, :H)
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
          @board.should == @board.to_a
        end
      end
    end

    describe "#[]" do
      before(:all) do
        @board = Board.new
        @board.add!(Ship.create(:D), Board.parse_pos("C2:H"))
        @board.add!(Ship.create(:S), :C, 1, :V)
      end
      context "when passed an integer" do
        it "returns the row from board with that index" do
          @board[0].should == @board.to_a[0]
        end
      end
      context "when passed a symbol" do
        it "returns the indexed row equivalent to that key symbol" do
          @board[:C].should == @board.to_a[2]
        end
      end
      context "when passed a string symbol" do
        it "returns the indexed row equivalent to that string symbol" do
          @board["J"].should == @board.to_a[9]
        end
      end
      context "when passed a string range" do
        it "returns the range of rows equivalent to that string range" do
          @board["B".."F"].should == @board.to_a[1..5]
        end
      end
      context "when passed a symbol range" do
        it "returns the range of rows equivalent to that symbol range" do
          @board[:C..:E].should == @board.to_a[2..4]
        end
      end
    end

    describe "#add!" do
      before(:each) do
        @board = Board.new
      end
      context "when passed a valid anchor" do
        it "returns the board with the ship added" do
          @ship = Ship.create(:P)
          @board.add!(@ship, :G, "1", "Vertical").should == Board.new.add!(Ship.create(:P), "G1:V")
        end
        context "with horizontal orientation" do
          it "updates the row equivalent to the index or symbol passed to reflect the ship position" do
            @ship = Ship.create(:S)
            @board.add!(@ship, "D", "2", "H")
            @board[:D][(1..1 + @ship.size - 1)].collect { |sector| sector.ship }.should == @ship.to_a
          end
        end
        context "with vertical orientation" do
          it "updates the column equivalent to the index passed to reflect the ship position" do
            @ship = Ship.create(:A)
            @board.add!(@ship, :B, 8, :V)
            @board[(:B..:F)].collect { |row| row[7].ship }.should == @ship.to_a
          end
        end
      end
      context "when passed invalid position" do
        it "returns false" do
          @board.add!(Ship.create(:D), "K6:h").should be false
        end
      end
    end

    describe "#dup" do
      before(:each) do
        @board = Board.new
      end
      it "returns a Board object" do
        @board.dup.should be_a Board
      end
      it "returns a shallow copy of the original Board object" do
        @board.dup.should == @board
      end
      it "returns a deep copy of the original Board object" do
        board = @board.dup
        board.add!(Ship.create(:S), :C, 4, :H)
        board.should_not == @board
      end
      context "when applying changes to the copy" do
        it "doen't change the original object" do
          board = @board.dup
          lambda { board.add!(Ship.create(:A), :C, 3, :H) }.should_not change @board, :to_a
        end
      end
    end

    describe "#to_hash" do
      before(:each) do
        @board = Board.new
      end
      it "returns a hash representation of the board where keys map to row letters and values to arrays of row cells" do
        hash = Hash.new { |hash, key| hash[key.to_sym] = Array.new(10) { Sector.new } }
        ("A".."J").each { |key| hash[key] }
        @board.to_hash.should == hash
      end
    end

    describe "#to_s" do
      before(:each) do
        @board = Board.new
        @board.add!(Ship.create(:A), :D, 4, :V)
      end
      context "when no additional arguments passed" do
        it "returns a string representation of the board and its ships" do
          @board.to_s.should == (<<-eos)
|   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
| A |   |   |   |   |   |   |   |   |   |   |
| B |   |   |   |   |   |   |   |   |   |   |
| C |   |   |   |   |   |   |   |   |   |   |
| D |   |   |   | A |   |   |   |   |   |   |
| E |   |   |   | A |   |   |   |   |   |   |
| F |   |   |   | A |   |   |   |   |   |   |
| G |   |   |   | A |   |   |   |   |   |   |
| H |   |   |   | A |   |   |   |   |   |   |
| I |   |   |   |   |   |   |   |   |   |   |
| J |   |   |   |   |   |   |   |   |   |   |
          eos
        end
      end
      context "when arguments are provided to override the defaults" do
        it "returns a representation of the board where empty sectors are filled with that character" do
          @board.to_s("~", "!", 5).should == <<-eos
!  ~  !  1  !  2  !  3  !  4  !  5  !  6  !  7  !  8  !  9  ! 10  !
!  A  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  B  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  C  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  D  !  ~  !  ~  !  ~  !  A  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  E  !  ~  !  ~  !  ~  !  A  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  F  !  ~  !  ~  !  ~  !  A  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  G  !  ~  !  ~  !  ~  !  A  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  H  !  ~  !  ~  !  ~  !  A  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  I  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
!  J  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !  ~  !
          eos
        end
      end
      it "should not change the board" do
        lambda { @board.to_s }.should_not change @board, :to_s
      end
    end
  end

  describe Sector do
    before(:each) do
      @sector = Sector.new
    end

    describe "#to_hash" do
      it "returns a hash representation of the sector" do
        @sector.ship = Ship.create(:B)
        @sector.to_hash.should == { :ship => @sector.ship }
      end
    end

    describe "#==" do
      it "compares sectors based on shot and ship attributes" do
        @sector.ship = Ship.create(:D)
        Sector.new(Ship.create(:D)).should == @sector
      end
    end

    describe "#to_s" do
      context "when the sector has no ship" do
        context "and no arguments are passed" do
          it "returns a string with a single space" do
            @sector.to_s.should == " "
          end
        end
        context "and an character argument is passed" do
          it "returns that character" do
            @sector.to_s("~").should == "~"
          end
        end
      end
      context "when the sector has a ship" do
        it "returns the return value of ship's to_s method" do
          @sector.ship = Ship.create(:S)
          @sector.to_s("~").should == @sector.ship.to_s
        end
      end
    end
  end
end
