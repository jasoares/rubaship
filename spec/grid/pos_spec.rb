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
        it "returns the rangified column range 8..10 when passed 3" do
          @pos.rangify!(3).should == (8..10)
        end

        it "returns the rangified column range 8..10 when passed a destroyer" do
          @pos.rangify!(Ship.create(:D)).should == (8..10)
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

      describe "#rangify!" do
        it "returns the rangified row range :G..:J when passed 4" do
          @pos.rangify!(4).should == (:G..:J)
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

      it "returns false when passed \"K7:V\"" do
        Pos.parse("K7:V").should be_nil
      end
    end

    describe ".is_valid?" do
      it "returns true when passed :C, 4, :H" do
        Pos.is_valid?(:C, 4, :V).should be true
      end

      it "returns true when passed :D, 10, :V" do
        Pos.is_valid?(:D, 10, :V).should be true
      end

      it "returns false when passed :K, 3, :H" do
        Pos.is_valid?(:K, 3, :H).should be false
      end
    end
  end
end
