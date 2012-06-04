require 'spec_helper.rb'

module Rubaship
  describe Grid do
    describe "::ROWS" do
      it "returns the array of valid grid rows" do
        Grid::ROWS.should == %w{ A B C D E F G H I J }
      end
    end

    describe ".col_to_idx" do
      context "when array_index is passed as true(default)" do
        it "returns the index of the String column passed" do
          Grid.col_to_idx("3", true).should be 2
        end

        it "returns the index of the Fixnum column passed" do
          Grid.col_to_idx(5).should be 4
        end

        it "returns the range index that matches the Range passed" do
          Grid.col_to_idx(3..6).should == (2..5)
        end
      end

      context "when array_index is passed as false" do
        it "returns the Fixnum column number that matches the String column passed" do
          Grid.col_to_idx("4", false).should be 4
        end

        it "returns the column number of the Fixnum column passed" do
          Grid.col_to_idx(5, false).should be 5
        end

        it "returns the column range matching the grid column numbers passed" do
          Grid.col_to_idx("4".."7", false).should == (4..7)
        end
      end

      it "raises an exception when an invalid column type is passed" do
        lambda { Grid.col_to_idx(:"2") }.should raise_error(InvalidColumnArgument)
      end
    end

    describe ".ori_to_sym" do
      context "when passed a String" do
        it "accepts the full word 'horizontal' or 'vertical'" do
          Grid.ori_to_sym("horizontal").should be :H
        end

        it "accepts a partial word 'horiz' or 'vertic'" do
          Grid.ori_to_sym("horiz").should be :H
        end

        it "accepts the initial letter of the word 'h' or 'v'" do
          Grid.ori_to_sym("v").should be :V
        end

        it "raises an InvalidOrientationArgument when the word is invalid" do
          lambda { Grid.ori_to_sym("vr") }.should raise_error(InvalidOrientationArgument)
        end
      end

      context "when passed a Symbol" do
        it "accepts the full word :HORIZONTAL or :vertical" do
          Grid.ori_to_sym(:HORIZONTAL).should be :H
        end

        it "accepts a partial word :Horiz or :vertic" do
          Grid.ori_to_sym(:Horiz).should be :H
        end

        it "accepts the initial letter of the word :h or :V" do
          Grid.ori_to_sym(:V).should be :V
        end

        it "raises an InvalidOrientationArgument when the word is invalid" do
          lambda { Grid.ori_to_sym(:hr) }.should raise_error(InvalidOrientationArgument)
        end
      end

      it "raises an InvalidOrientationArgument when a non valid type is passed" do
        lambda { Grid.ori_to_sym(4) }.should raise_error(InvalidOrientationArgument)
      end
    end

    describe ".parse_pos" do
      it "parses the string and returns an array with the items parsed" do
        Grid.parse_pos("A7:H").should ==  [:A, 7, :H]
      end

      it "returns nil when the position in the string is invalid" do
        Grid.parse_pos("A11:H").should be_nil
      end
    end

    describe ".position_valid?" do
      before(:all) { @ship = Ship.create(:A) }

      it "returns true if the position is valid" do
        Grid.position_valid?(@ship, :C, 7, :V).should be true
      end

      it "returns false if the position is out of the grid and so invalid" do
        Grid.position_valid?(@ship, :C, 7, :H).should be false
      end
    end

    describe ".row_to_idx" do
      it "accepts a String letter matching it to its grid index" do
        Grid.row_to_idx("C").should be 2
      end

      it "accepts a Symbol letter matching it to its grid index" do
        Grid.row_to_idx(:D).should be 3
      end

      it "accepts a String Range and converts it to an array index range" do
        Grid.row_to_idx("B".."D").should == (1..3)
      end

      it "accepts a Symbol Range and converts it to an array index range" do
        Grid.row_to_idx(:C..:E).should == (2..4)
      end

      it "returns the argument unchanged when passed a Fixnum" do
        Grid.row_to_idx(3).should == 3
      end

      it "returns the argument unchanged when passed a Fixnum Range" do
        Grid.row_to_idx(3..5).should == (3..5)
      end

      it "raises an exception when passed any other type" do
        lambda { Grid.row_to_idx([2]) }.should raise_error(InvalidRowArgument)
      end
    end

    before(:each) { @grid = Grid.new }

    describe "#[]" do
      context "for an example grid already containing ships" do
        before(:all) do
          @grid = Grid.new
          @grid.add!(Ship.create(:D), :C, 2, :H)
          @grid.add!(Ship.create(:S), :C, 1, :V)
        end

        it "returns the row with the ships contained in sectors" do
          @grid[:C].should == @grid.row(2)
        end

        it "returns the indexed row matching the letter Symbol passed" do
          @grid[:C].should == @grid.row(2)
        end

        it "returns the indexed row matching the letter String passed" do
          @grid["J"].should == @grid.row(9)
        end

        it "returns the range of rows matching the string range passed" do
          @grid["B".."F"].should == @grid.row(1..5)
        end

        it "returns the range of rows matching the symbol range passed" do
          @grid[:C..:E].should == @grid.row(2..4)
        end
      end
    end

    describe "#==" do
      before(:all) do
        @grid1, @grid2, @grid3 = Grid.new, Grid.new, Grid.new
        @grid1.add!(Ship.create(:D), :G, 3, :H)
        @grid2.add!(Ship.create(:D), :G, 3, :H)
        @grid3.add!(Ship.create(:D), :G, 4, :H)
      end

      it "returns true when both grid objects are equal" do
        @grid1.should == @grid2
      end

      it "returns false when grid objects differ" do
        @grid1.should_not == @grid3
      end

      it "returns true if the to_hash method equals the hash passed" do
        @grid1.should == @grid2.to_hash
      end

      it "returns false if the to_hash method differs from the hash passed" do
        @grid1.should_not == @grid3.to_hash
      end

      it "returns true if the to_a method equals the array passed" do
        @grid1.should == @grid2.to_a
      end

      it "returns false if the to_a method differs from the array passed" do
        @grid1.should_not == @grid3.to_a
      end
    end

    describe "#add" do
      it "returns a grid object with the ship added" do
        grid = Grid.new.add(Ship.create(:B), :a, 10, :v)
        @grid.add(Ship.create(:B), :A, 10, :V).should == grid
      end

      it "does not change the receiver object. See Grid#add!" do
        lambda {
          @grid.add(Ship.create(:A), :j, 2, :h)
        }.should_not change @grid, :to_a
      end
    end

    describe "#add!" do
      before(:all) { @ship = Ship.create(:S) }

      it "returns the grid with the ship added when passed a valid position" do
        grid = Grid.new.add!(@ship, :G, 1, :V)
        @grid.add!(@ship, :G, 1, :V).should == grid
      end

      it "updates the matching row when horizontal is passed" do
        @grid.add!(@ship, :D, 4, :H)
        @grid[:D][(3..3 + @ship.size - 1)].collect do |sector|
          sector.ship
        end.should == @ship.to_a
      end

      it "updates the matching column when vertical is passed" do
        @grid.add!(@ship, :B, 8, :V)
        @grid[(1..1 + @ship.size - 1)].collect do |row|
          row[7].ship
        end.should == @ship.to_a
      end

      it "changes the receiver object" do
        lambda do
          @grid.add!(@ship, :B, 3, :H)
        end.should change @grid, :to_a
      end

      it "raises InvalidColumnArgument when passed an invalid column" do
        lambda do
          @grid.add!(@ship, :C, 11, :H)
        end.should raise_error(
          InvalidColumnArgument,
          /^Invalid column or range type passed .+$/
        )
      end

      it "raises InvalidRowArgument when passed an invalid row" do
        lambda do
          @grid.add!(@ship, :K, 6, :H)
        end.should raise_error(
          InvalidRowArgument,
          /^Invalid row or range type passed .+$/
        )
      end
    end

    describe "#col" do
      it "returns an array containing the sectors of the given column" do
        @ship = Ship.create(:D)
        @grid.add!(@ship, :F, 3, :V)
        es = Sector.new         # empty_sector
        ss = Sector.new(@ship)  # ship_sector
        @grid.col(3).should == [es, es, es, es, es, ss, ss, ss, es, es]
      end
    end

    describe "#dup" do
      it "returns a Grid object" do
        @grid.dup.should be_a Grid
      end

      it "returns a deep copy of the original Grid object" do
        @grid.dup.should == @grid
      end

      it "doesn't change the original object when applying changes to the copy" do
        grid = @grid.dup
        lambda { grid.add!(Ship.create(:A), :C, 3, :H) }.should_not change @grid, :to_a
      end
    end

    describe "#each" do
      it "iterates over each of the 100 sectors of the grid" do
        @grid.collect { |sector| sector }.should have(100).sectors
      end

      it "returns an enumerator when no block given" do
        @grid.each.should be_an Enumerator
      end
    end

    describe "#each_col" do
      it "iterates over each of the 10 columns" do
        @grid.each_col { |col| col.should have(10).sectors }
      end

      it "returns an enumerator when no block given" do
        @grid.each_col.should be_an Enumerator
      end
    end

    describe "#each_row" do
      it "iterates over each of the 10 rows" do
        @grid.each_row { |row| row.should have(10).sectors }
      end

      it "returns an enumerator when no block given" do
        @grid.each_row.should be_an Enumerator
      end
    end

    describe "#row" do
      it "alias the Grid#[] method" do
        @grid.add!(Ship.create(:B), :A, 2, :H)
        @grid.row(:A).should == @grid[:A]
      end
    end

    describe "#sector" do
      it "returns a single sector which coordinates correspond to col and row to idx" do
        @grid.add!(Ship.create(:S), :D, 7, :V)
        @grid.sector(:E, 7).should == Sector.new(Ship.create(:S))
      end
    end

    describe "#to_a" do
      it "returns an array" do
        @grid.to_a.should be_an Array
      end

      it "is a deep copy of the Grid object inner array" do
        lambda { @grid.to_a[1][2] = "S" }.should_not change @grid, :to_a
      end
    end

    describe "#to_hash" do
      it "returns a hash representation of the grid where keys map to row letters and values to arrays of row cells" do
        hash = Hash.new { |hash, key| hash[key.to_sym] = Array.new(10) { Sector.new } }
        ("A".."J").each { |key| hash[key] }
        @grid.to_hash.should == hash
      end
    end

    describe "#to_s" do
      before(:each) do
        @grid.add!(Ship.create(:A), :D, 4, :V)
      end
      context "when no additional arguments passed" do
        it "returns a string representation of the grid" do
          @grid.to_s.should == (<<-eos)
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
        it "returns a representation of the grid where empty sectors are filled with that character" do
          @grid.to_s("~", "!", 5).should == <<-eos
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
      it "should not change the grid" do
        lambda { @grid.to_s }.should_not change @grid, :to_s
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

    describe "#ship=" do
      context "when it already contains a ship" do
        before(:each) do
          @sector = Sector.new
          @sector.ship = Ship.create(:A)
        end

        it "raises an InvalidShipPosition if it already contains a ship" do
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
