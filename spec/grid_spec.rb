require 'spec_helper.rb'

module Rubaship
  describe Grid do
    before(:each) { @grid = Grid.new }

    describe "#[]" do
      context "given a sample grid with an aircraft carrier at A1:V" do
        before(:each) do
          @ship = Ship.create(:A)
          @grid.add!(@ship, :A, 1, :V)
        end

        it "returns the sector C4 when passed [:C, 1]" do
          @grid[:C, 1].should == Sector.new(@ship)
        end

        it "returns the row D when passed [:D]" do
          @grid[:D].should == @grid.row(:D)
        end

        it "returns the column 1 when passed [1]" do
          @grid[1].should == @grid.col(1)
        end

        it "returns the columns 1 to 3 when passed [1..3]" do
          res = @grid.to_a[0..9].transpose[0..2].transpose
          @grid[1..3].should == res
        end

        it "returns the rows B to D when passed [:B..:D]" do
          @grid[:B..:D].should == @grid.row(:B..:D)
        end

        it "returns an array of the ship sectors when passed [:A..:E, 1]" do
          @grid[:A..:E, 1].should == Array.new(5, Sector.new(@ship))
        end

        it "returns a subgrid of sectors when passed [:A..:E, 1..2]" do
          res = Array.new(5, [Sector.new(@ship), Sector.new])
          @grid[:A..:E, 1..2].should == res
        end

        it "returns a subgrid of sectors [[A,  ] [A,  ]] when passed [:D..:E, 1..2]" do
          res = Array.new(2, [Sector.new(@ship), Sector.new])
          @grid[:D..:E, 1..2].should == res
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
        @grid.col(8)[1..3].should == Array.new(3, Sector.new(@ship))
      end

      it "changes the receiver object" do
        lambda do
          @grid.add!(@ship, :B, 3, :H)
        end.should change @grid, :to_hash
      end

      it "raises InvalidColArgument when passed an invalid column" do
        lambda do
          @grid.add!(@ship, :C, 11, :H)
        end.should raise_error(
          InvalidColArgument,
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

    describe "#sector" do
      it "returns a single sector which coordinates correspond to col and row to idx" do
        @grid.add!(Ship.create(:S), :D, 7, :V)
        @grid.sector(:E, 7).should == Sector.new(Ship.create(:S))
      end
    end

    describe "#to_a" do
      context "given a sample grid with ships already placed" do
        before(:each) do
          @grid.add!(Ship.create(:B), :D, 3, :H)
        end

        it "returns an array" do
          @grid.to_a.should be_an Array
        end

        it "returns the Grid object's inner array" do
          @grid.to_a.should == @grid[:A..:J, 1..10]
        end
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
end
