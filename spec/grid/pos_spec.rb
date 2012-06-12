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

    context "for a sample position of :B, 4, :H" do
      before(:each) do
        @pos = Pos.new(:B, 4, :H)
      end

      describe "#row" do
        it "returns :B" do
          @pos.row.should == Row.new(:B)
        end
      end

      describe "#col" do
        it "returns 4" do
          @pos.col.should == Col.new(4)
        end
      end

      describe "#ori" do
        it "returns :H" do
          @pos.ori.should == Ori.new(:H)
        end
      end

      describe "#rangify!" do
        it "returns the rangified column range 4..8 when passed 5" do
          @pos.rangify!(5).should == (4..8)
        end

        it "changes the column from 4 to 4..6 when passed 3" do
          lambda {
            @pos.rangify!(3)
          }.should change(@pos, :to_a).from([:B, 4, :H]).to([:B, 4..6, :H])
        end

        it "changes the column range? status from false to true" do
          lambda {
            @pos.rangify!(3)
          }.should change(@pos.col, :range?).from(false).to(true)
        end
      end

      describe "#==" do
        it "should == [:B, 4, :H]" do
          @pos.should == [:B, 4, :H]
        end

        it "should == \"B4:H\"" do
          @pos.should == "B4:H"
        end

        it "should == Pos.new(:B, 4, :H)" do
          @pos.should == Pos.new(:B, 4, :H)
        end

        it "should == [Row.new(:B), Col.new(4), Ori.new(:H)]" do
          @pos.should == [Row.new(:B), Col.new(4), Ori.new(:H)]
        end
      end
    end

    context "for a sample position of :F, 7, :V" do
      before(:each) do
        @pos = Pos.new(:F, 7, :V)
      end

      describe "#row" do
        it "returns :F" do
          @pos.row.should == Row.new(:F)
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
        it "returns the rangified row range :F..:J when passed 5" do
          @pos.rangify!(5).should == (:F..:J)
        end

        it "changes the row from :F to :F..:I when passed 4" do
          lambda {
            @pos.rangify!(4)
          }.should change(@pos, :to_a).from([:F, 7, :V]).to([:F..:I, 7, :V])
        end

        it "changes the row range? status from false to true" do
          lambda {
            @pos.rangify!(3)
          }.should change(@pos.row, :range?).from(false).to(true)
        end
      end

      describe "#==" do
        it "should == [:F, 7, :V]" do
          @pos.should == [:F, 7, :V]
        end

        it "should == \"F7:V\"" do
          @pos.should == "F7:V"
        end

        it "should == Pos.new(:F, 7, :V)" do
          @pos.should == Pos.new(:F, 7, :V)
        end

        it "should == [Row.new(:F), Col.new(7), Ori.new(:V)]" do
          @pos.should == [Row.new(:F), Col.new(7), Ori.new(:V)]
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
