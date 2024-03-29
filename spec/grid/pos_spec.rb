require 'spec_helper.rb'

module Rubaship
  describe Pos do
    it "accepts a string with a valid position" do
      Pos.new("C3:V").should == [:C, 3, :V]
    end

    it "accepts a sequence of Row, Col and Ori objects" do
      Pos.new(Row.new(:A), Col.new(3), Ori.new(:H)).should == [:A, 3, :H]
    end

    it "accepts a sequence of :D, 3, :V" do
      Pos.new(:D, 3, :V).should == [:D, 3, :V]
    end

    it "accepts a range row :B..:E and a column 3 without an orientation" do
      Pos.new(:B..:E, 3).should == [:B..:E, 3, :V]
    end

    it "forces the orientation to :H when passed a column range" do
      lambda { Pos.new(:B, 3..7, :V) }.should raise_error(
        InvalidPositionArgument,
        "Either row or col must be a Range matching the orientation argument if any."
      )
    end

    it "raises an InvalidPositionArgument when passed :C..:E, 4..7" do
      lambda { Pos.new(:C..:E, 4..7) }.should raise_error(
        InvalidPositionArgument,
        "Either row or col must be a Range matching the orientation argument if any."
      )
    end

    it "raises an InvalidPositionArgument when passed :C, 3" do
      lambda { Pos.new(:C, 3) }.should raise_error(
        InvalidPositionArgument,
        "Either row or col must be a Range matching the orientation argument if any."
      )
    end

    context "for a sample position of :B, 8, :H" do
      before(:each) do
        @pos = Pos.new(:B, 8, :H)
      end

      describe "#row" do
        it "returns :B" do
          @pos.row.should == Row.new(:B)
        end
      end

      describe "#col" do
        it "returns 8" do
          @pos.col.should == Col.new(8)
        end
      end

      describe "#ori" do
        it "returns :H" do
          @pos.ori.should == Ori.new(:H)
        end
      end

      describe "#rangify!" do
        it "returns the position rangified :B, 8..10, :H, when passed 3" do
          @pos.rangify!(3).should == [:B, 8..10, :H]
        end

        it "returns the position rangified :B, 8..10, :H, when passed a destroyer" do
          @pos.rangify!(Ship.create(:D)).should == [:B, 8..10, :H]
        end

        it "changes the column from 8 to 8..9 when passed 2" do
          lambda {
            @pos.rangify!(2)
          }.should change(@pos, :to_a).from([:B, 8, :H]).to([:B, 8..9, :H])
        end

        it "changes the column range? status from false to true" do
          lambda {
            @pos.rangify!(3)
          }.should change(@pos.col, :range?).from(false).to(true)
        end
      end

      describe "#to_a" do
        it "returns [:B, 8, :H]" do
          @pos.to_a.should == [:B, 8, :H]
        end
      end

      describe "#to_s" do
        it "returns B8:H" do
          @pos.to_s.should == "B8:H"
        end
      end

      describe "#==" do
        it "should == [:B, 8, :H]" do
          @pos.should == [:B, 8, :H]
        end

        it "should == \"B8:H\"" do
          @pos.should == "B8:H"
        end

        it "should == Pos.new(:B, 8, :H)" do
          @pos.should == Pos.new(:B, 8, :H)
        end

        it "should == [Row.new(:B), Col.new(8), Ori.new(:H)]" do
          @pos.should == [Row.new(:B), Col.new(8), Ori.new(:H)]
        end
      end
    end

    context "for a sample position of :G, 7, :V" do
      before(:each) do
        @pos = Pos.new(:G, 7, :V)
      end

      describe "#row" do
        it "returns :G" do
          @pos.row.should == Row.new(:G)
        end
      end

      describe "#col" do
        it "returns 7" do
          @pos.col.should == Col.new(7)
        end
      end

      describe "#ori" do
        it "returns :V" do
          @pos.ori.should == Ori.new(:V)
        end
      end

      describe "#range?" do
        it "returns false" do
          @pos.range?.should be false
        end
      end

      describe "#rangify!" do
        it "returns the rangified position :G..:J, 7 when passed 4" do
          @pos.rangify!(4).should == [:G..:J, 7, :V]
        end

        it "changes the row from :G to :G..:I when passed 3" do
          lambda {
            @pos.rangify!(3)
          }.should change(@pos, :to_a).from([:G, 7, :V]).to([:G..:I, 7, :V])
        end

        it "changes the row range? status from false to true" do
          lambda {
            @pos.rangify!(3)
          }.should change(@pos.row, :range?).from(false).to(true)
        end
      end

      describe "#to_a" do
        it "returns [:G, 7, :V]" do
          @pos.to_a.should == [:G, 7, :V]
        end
      end

      describe "#to_s" do
        it "returns G7:V" do
          @pos.to_s.should == "G7:V"
        end
      end

      describe "#valid?" do
        it "returns true when passed a Battleship" do
          @pos.valid?(Ship.create(:B)).should be true
        end

        it "returns false when passed an Aircraft Carrier" do
          @pos.valid?(Ship.create(:A)).should be false
        end
      end

      describe "#==" do
        it "should == [:G, 7, :V]" do
          @pos.should == [:G, 7, :V]
        end

        it "should == \"G7:V\"" do
          @pos.should == "G7:V"
        end

        it "should == Pos.new(:G, 7, :V)" do
          @pos.should == Pos.new(:G, 7, :V)
        end

        it "should == [Row.new(:G), Col.new(7), Ori.new(:V)]" do
          @pos.should == [Row.new(:G), Col.new(7), Ori.new(:V)]
        end
      end
    end

    context "for a sample position with a range of rows :D..:G and 3" do
      before(:each) do
        @pos = Pos.new(:D..:G, 3)
      end

      describe "#row" do
        it "returns :D..:G" do
          @pos.row.should == Row.new(:D..:G)
        end
      end

      describe "#col" do
        it "returns 3" do
          @pos.col.should == Col.new(3)
        end
      end

      describe "#ori" do
        it "returns :V" do
          @pos.ori.should == Ori.new(:V)
        end
      end

      describe "#range?" do
        it "returns true" do
          @pos.range?.should be true
        end
      end

      describe "#rangify!" do
        it "returns the position unchanged since it is already a range" do
          lambda { @pos.rangify!(4) }.should_not change(@pos, :to_a)
        end
      end

      describe "#to_a" do
        it "returns [:D..:G, 3, :V]" do
          @pos.to_a.should == [:D..:G, 3, :V]
        end
      end

      describe "#to_s" do
        it "returns D..G3:V" do
          @pos.to_s.should == "D..G3:V"
        end
      end

      describe "#valid?" do
        it "returns true when passed a Battleship" do
          @pos.valid?(Ship.create(:B)).should be true
        end

        it "returns false when passed an Aircraft Carrier" do
          @pos.valid?(Ship.create(:A)).should be false
        end
      end

      describe "#==" do
        it "should == [:D..:G, 3, :V]" do
          @pos.should == [:D..:G, 3, :V]
        end

        it "should not == \"D3:V\"" do
          @pos.should_not == "D3:V"
        end

        it "should == Pos.new(:D..:G, 3, :V)" do
          @pos.should == Pos.new(:D..:G, 3, :V)
        end

        it "should == Pos.new(:D..:G, 3)" do
          @pos.should == Pos.new(:D..:G, 3)
        end

        it "should == [Row.new(:D..:G), Col.new(3), Ori.new(:V)]" do
          @pos.should == [Row.new(:D..:G), Col.new(3), Ori.new(:V)]
        end
      end
    end

    describe ".is_valid?" do
      it "returns true when passed :C, 4, :H" do
        Pos.is_valid?(:C, 4, :V).should be true
      end

      it "returns true when passed :D, 10, :V" do
        Pos.is_valid?(:D, 10, :V).should be true
      end

      it "returns true when passed :D..:F, 6, :V" do
        Pos.is_valid?(:D..:F, 6, :V).should be true
      end

      it "returns true when passed :D, 4..7, :H" do
        Pos.is_valid?(:D, 4..7, :H).should be true
      end

      it "returns true when passed :D, 4..7 with no orientation" do
        Pos.is_valid?(:D, 4..7).should be true
      end

      it "returns false when passed :K, 3, :H" do
        Pos.is_valid?(:K, 3, :H).should be false
      end

      it "returns false when passed :A..:D, 5, :H" do
        Pos.is_valid?(:A..:D, 5, :H).should be false
      end

      it "returns false when passed :C, 5..8, :V" do
        Pos.is_valid?(:C, 5..8, :V).should be false
      end
    end

    describe ".format" do
      it "returns [:A, 3, :H] when passed \"A\", 3, \"horizontal\"" do
        Pos.format("A", "3", "horizontal").should == [:A, 3, :H]
      end

      it "returns [:C..:H, 3, :V] when passed \"C\"..\"H\", \"3\", \"Vert\"" do
        Pos.format("C".."H", "3", "Vert").should == [:C..:H, 3, :V]
      end
    end

    describe ".parse" do
      it "returns [:A, 3, :H] when passed \"A3:H\"" do
        Pos.parse("A3:H").should == [:A, 3, :H]
      end

      it "returns [:C, 7, :H] when passed \"C7:H\"" do
        Pos.parse("C7:H").should == [:C, 7, :H]
      end

      it "returns [:E, 10, :V] when passed \"E10:V\"" do
        Pos.parse("E10:V").should == [:E, 10, :V]
      end

      it "returns nil when passed\"B11:H\"" do
        Pos.parse("B11:H").should be_nil
      end

      it "returns nil when passed \"K7:V\"" do
        Pos.parse("K7:V").should be_nil
      end
    end

    describe ".to_a" do
      it "returns [:A, 3, :H] when passed :A, 3, :H" do
        Pos.to_a(:A, 3, :H).should == [:A, 3, :H]
      end

      it "returns [:A..:D, 4, :V] when passed :A..:D, 4, :V" do
        Pos.to_a(:A..:D, 4, :V).should == [:A..:D, 4, :V]
      end

      it "returns [:A..:D, 4, :V] when passed :A..:D, 4" do
        Pos.to_a(:A..:D, 4).should == [:A..:D, 4, :V]
      end

      it "returns [:C..:I, 3, :V] when passed Pos.new(:C..:I, 3, :V)" do
        Pos.to_a(Pos.new(:C..:I, 3, :V)).should == [:C..:I, 3, :V]
      end

      it "returns [:D, 6, :H] when passed \"D6:H\"" do
        Pos.to_a("D6:H").should == [:D, 6, :H]
      end

      it "raises InvalidPositionArgument when passed a row range and :H" do
        lambda { Pos.to_a(:D..:G, 6, :H) }.should raise_error(
          InvalidPositionArgument,
          "Either row or col must be a Range matching the orientation argument if any."
        )
      end

      it "raises InvalidPositionArgument when passed a col range and :V" do
        lambda { Pos.to_a(:D, 6..9, :V) }.should raise_error(
          InvalidPositionArgument,
          "Either row or col must be a Range matching the orientation argument if any."
        )
      end

      it "raises InvalidPositionArgument when passed a row range and a col range" do
        lambda { Pos.to_a(:D..:G, 6..9, :H) }.should raise_error(
          InvalidPositionArgument,
          "Either row or col must be a Range matching the orientation argument if any."
        )
      end

      it "raises InvalidPositionArgument when passed no range and no orientation" do
        lambda { Pos.to_a(:D, 6) }.should raise_error(
          InvalidPositionArgument,
          "Either row or col must be a Range matching the orientation argument if any."
        )
      end
    end
  end
end
