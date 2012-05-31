require 'spec_helper.rb'

module Rubaship
  describe Board do
    describe "::ROWS" do
      it "returns the array of valid board rows" do
        Board::ROWS.should == %w{ A B C D E F G H I J }
      end
    end

    describe ".col_to_idx" do
      context "when array_index is passed as true(default)" do
        it "returns the index of the String column passed" do
          Board.col_to_idx("3", true).should be 2
        end

        it "returns the index of the Fixnum column passed" do
          Board.col_to_idx(5).should be 4
        end

        it "returns the range index that matches the Range passed" do
          Board.col_to_idx(3..6).should == (2..5)
        end

        it "raises an exception when an invalid column type is passed" do
          lambda { Board.col_to_idx(:"2") }.should raise_error(InvalidColumnArgument)
        end
      end

      context "when array_index is passed as false" do
        it "returns the Fixnum column number that matches the String column passed" do
          Board.col_to_idx("4", false).should be 4
        end

        it "returns the column number of the Fixnum column passed" do
          Board.col_to_idx(5, false).should be 5
        end

        it "returns the column range matching the board column numbers passed" do
          Board.col_to_idx("4".."7", false).should == (4..7)
        end

        it "raises an exception when passed an invalid column type" do
          lambda { Board.col_to_idx(:"2") }.should raise_error(InvalidColumnArgument)
        end
      end
    end

    describe ".ori_to_sym" do
      context "when passed a String" do
        it "accepts the full word 'horizontal' or 'vertical'" do
          Board.ori_to_sym("horizontal").should be :H
        end

        it "accepts a partial word 'horiz' or 'vertic'" do
          Board.ori_to_sym("horiz").should be :H
        end

        it "accepts the initial letter of the word 'h' or 'v'" do
          Board.ori_to_sym("v").should be :V
        end

        it "raises an InvalidOrientationArgument when the word is invalid" do
          lambda { Board.ori_to_sym("vr") }.should raise_error(InvalidOrientationArgument)
        end
      end

      context "when passed a Symbol" do
        it "accepts the full word :HORIZONTAL or :vertical" do
          Board.ori_to_sym(:HORIZONTAL).should be :H
        end

        it "accepts a partial word :Horiz or :vertic" do
          Board.ori_to_sym(:Horiz).should be :H
        end

        it "accepts the initial letter of the word :h or :V" do
          Board.ori_to_sym(:V).should be :V
        end

        it "raises an InvalidOrientationArgument when the word is invalid" do
          lambda { Board.ori_to_sym(:hr) }.should raise_error(InvalidOrientationArgument)
        end
      end

      it "raises an InvalidOrientationArgument when a non valid type is passed" do
        lambda { Board.ori_to_sym(4) }.should raise_error(InvalidOrientationArgument)
      end
    end

    describe ".parse_pos" do
      it "parses the string and returns an array with the items parsed" do
        Board.parse_pos("A7:H").should ==  [:A, 7, :H]
      end

      it "returns nil when the position in the string is invalid" do
        Board.parse_pos("A11:H").should be_nil
      end
    end

    describe ".row_to_idx" do
      it "accepts a String letter matching it to its board index" do
        Board.row_to_idx("C").should be 2
      end

      it "accepts a Symbol letter matching it to its board index" do
        Board.row_to_idx(:D).should be 3
      end

      it "accepts a String Range and converts it to an array index range" do
        Board.row_to_idx("B".."D").should == (1..3)
      end
      
      it "accepts a Symbol Range and converts it to an array index range" do
        Board.row_to_idx(:C..:E).should == (2..4)
      end

      it "returns the argument unchanged when passed a Fixnum" do
        Board.row_to_idx(3).should == 3
      end

      it "returns the argument unchanged when passed a Fixnum Range" do
        Board.row_to_idx(3..5).should == (3..5)
      end

      it "raises an exception when passed any other type" do
        lambda { Board.row_to_idx([2]) }.should raise_error(InvalidRowArgument)
      end
    end

    describe "#[]" do
      context "for an example board already containing ships" do
        before(:all) do
          @board = Board.new
          @board.add!(Ship.create(:D), :C, 2, :H)
          @board.add!(Ship.create(:S), :C, 1, :V)
        end

        it "returns the row with the ships contained in sectors" do
          @board[:C].should == @board.row(2)
        end

        it "returns the indexed row matching the letter Symbol passed" do
          @board[:C].should == @board.row(2)
        end

        it "returns the indexed row matching the letter String passed" do
          @board["J"].should == @board.row(9)
        end

        it "returns the range of rows matching the string range passed" do
          @board["B".."F"].should == @board.row(1..5)
        end

        it "returns the range of rows matching the symbol range passed" do
          @board[:C..:E].should == @board.row(2..4)
        end
      end
    end

    describe "#==" do
      before(:all) do
        @board1 = Board.new
        @board1.add!(Ship.create(:D), :G, 3, :H)
        @board2 = Board.new
        @board2.add!(Ship.create(:D), :G, 3, :H)
        @board3 = Board.new
        @board3.add!(Ship.create(:D), :G, 4, :H)
      end

      it "returns true when both board objects are equal" do
        @board1.should == @board2
      end

      it "returns false when board objects differ" do
        @board1.should_not == @board3
      end

      it "returns true if the to_hash method equals the hash passed" do
        @board1.should == @board2.to_hash
      end

      it "returns false if the to_hash method differs from the hash passed" do
        @board1.should_not == @board3.to_hash
      end

      it "returns true if the to_a method equals the array passed" do
        @board1.should == @board2.to_a
      end

      it "returns false if the to_a method differs from the array passed" do
        @board1.should_not == @board3.to_a
      end
    end

    describe "#add" do
      before(:each) { @board = Board.new }

      it "returns a board object with the ship added" do
        @board.add(Ship.create(:B), :A, 10, :V).should == Board.new.add(Ship.create(:B), :a, 10, :v)
      end

      it "does not change the receiver object. See Board#add!" do
        lambda { @board.add(Ship.create(:A), :j, 2, :h) }.should_not change @board, :to_a
      end
    end

    describe "#add!" do
      before(:all) { @ship = Ship.create(:S) }

      before(:each) { @board = Board.new }

      it "returns the board with the ship added when passed a valid position" do
        @board.add!(@ship, :G, "1", "Vertical").should == Board.new.add!(@ship, "G1:V")
      end

      it "updates the matching row when horizontal is passed" do
        @board.add!(@ship, :D, 4, :H)
        @board[:D][(3..3 + @ship.size - 1)].collect { |sector| sector.ship }.should == @ship.to_a
      end

      it "updates the matching column when vertical is passed" do
        @board.add!(@ship, :B, 8, :V)
        @board[(1..1 + @ship.size - 1)].collect { |row| row[7].ship }.should == @ship.to_a
      end

      it "changes the receiver object" do
        lambda { @board.add!(Ship.create(:A), :B, 3, :H) }.should change @board, :to_a
      end

      it "returns false when passed an invalid position" do
        @board.add!(@ship, "K6:h").should be false
      end

      it "raises an InvalidShipArgument error when passed an invalid ship" do
        lambda { @board.add!(:D, "D3:h") }.should raise_error(InvalidShipArgument)
      end
    end

    describe "#col" do
      it "returns an array containing the sectors of the given column" do
        @board = Board.new
        @ship = Ship.create(:D)
        @board.add!(@ship, :F, 3, :V)
        es = Sector.new         # empty_sector
        ss = Sector.new(@ship)  # ship_sector
        @board.col(3).should == [es, es, es, es, es, ss, ss, ss, es, es]
      end
    end

    describe "#dup" do
      before(:each) { @board = Board.new }

      it "returns a Board object" do
        @board.dup.should be_a Board
      end

      it "returns a deep copy of the original Board object" do
        @board.dup.should == @board
      end

      it "doesn't change the original object when applying changes to the copy" do
        board = @board.dup
        lambda { board.add!(Ship.create(:A), :C, 3, :H) }.should_not change @board, :to_a
      end
    end

    describe "#each" do
      before(:each) { @board = Board.new }

      it "iterates over each of the 100 sectors of the board" do
        @board.collect { |sector| sector }.should have(100).sectors
      end

      it "returns an enumerator when no block given" do
        @board.each.should be_an Enumerator
      end
    end

    describe "#each_col" do
      before(:each) { @board = Board.new }

      it "iterates over each of the 10 columns" do
        @board.each_col { |col| col.should have(10).sectors }
      end

      it "returns an enumerator when no block given" do
        @board.each_col.should be_an Enumerator
      end
    end

    describe "#each_row" do
      before(:each) { @board = Board.new }

      it "iterates over each of the 10 rows" do
        @board.each_row { |row| row.should have(10).sectors }
      end

      it "returns an enumerator when no block given" do
        @board.each_row.should be_an Enumerator
      end
    end

    describe "#row" do
      it "alias the Board#[] method" do
        @board = Board.new
        @board.add!(Ship.create(:B), :A, 2, :H)
        @board.row(:A).should == @board[:A]
      end
    end

    describe "#sector" do
      it "returns a single sector which coordinates respond to col and row to idx" do
        @board = Board.new
        @board.add!(Ship.create(:S), :D, 7, :V)
        @board.sector(:E, 7).should == Sector.new(Ship.create(:S))
      end
    end

    describe "#to_a" do
      before(:each) { @board = Board.new }

      it "returns an array" do
        @board.to_a.should be_an Array
      end

      it "is a deep copy of the Board object inner array" do
        lambda { @board.to_a[1][2] = "S" }.should_not change @board, :to_a
      end
    end

    describe "#to_hash" do
      it "returns a hash representation of the board where keys map to row letters and values to arrays of row cells" do
        @board = Board.new
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
        it "returns a string representation of the board" do
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
