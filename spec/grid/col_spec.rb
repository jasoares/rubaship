require 'spec_helper.rb'

module Rubaship
  describe Col::COLS do
    it "keeps a String array of valid columns" do
      Col::COLS.should == ("1".."10").to_a
    end
  end

  describe Col do
    it "accepts a column number based Fixnum" do
      Col.new(1).should == 1
    end

    it "accepts a String with a column number" do
      Col.new("10").should == 10
    end

    it "accepts a column number based Fixnum Range" do
      Col.new(4..6).should == (4..6)
    end

    it "accepts a String Range with column numbers" do
      Col.new("3".."6").should == (3..6)
    end

    it "raises an InvalidColArgument error when passed \"11\"" do
      lambda { Col.new("11") }.should raise_error(
        InvalidColArgument,
        /^Invalid column or range type passed .+$/
      )
    end

    it "raises an InvalidColArgument error when passed 0" do
      lambda { Col.new(0) }.should raise_error(
        InvalidColArgument,
        /^Invalid column or range type passed .+$/
      )
    end

    context "for a sample column created with the non zero based value 5" do
      before(:each) do
        @col = Col.new(5)
      end

      describe "#range?" do
        it "returns false" do
          @col.range?.should be false
        end
      end

      describe "#rangify!" do
        it "returns 5..8 when passed a size of 4" do
          @col.rangify!(4).should == (5..8)
        end
      end

      describe "#size" do
        it "returns 1" do
          @col.size.should be 1
        end
      end

      describe "#to_idx" do
        it "returns 4" do
          @col.to_idx.should be 4
        end
      end

      describe "#to_s" do
        it "returns \"5\"" do
          @col.to_s.should == "5"
        end
      end

      describe "#to_i" do
        it "returns 5" do
          @col.to_i.should be 5
        end
      end

      describe "#==" do
        it "should == 5" do
          @col.should == 5
        end

        it "should == \"5\"" do
          @col.should == "5"
        end

        it "should == Col.new(5)" do
          @col.should == Col.new(5)
        end
      end
    end

    context "for a sample column which is the range of columns 3..7" do
      before(:each) do
        @col = Col.new(3..7)
      end

      describe "#range?" do
        it "returns true" do
          @col.range?.should be true
        end
      end

      describe "#rangify!" do
        it "returns false to indicate it is already a range" do
          @col.rangify!(3).should be false
        end
      end

      describe "#size" do
        it "returns 5" do
          @col.size.should be 5
        end
      end

      describe "#to_idx" do
        it "returns 2..6" do
          @col.to_idx.should == (2..6)
        end
      end

      describe "#to_s" do
        it "returns \"3\"..\"6\"" do
          @col.to_s.should == ("3".."7")
        end
      end

      describe "#to_i" do
        it "returns 3..6" do
          @col.to_i.should == (3..7)
        end
      end

      describe "#==" do
        it "should == 3..6" do
          @col.should == (3..7)
        end

        it "should == \"3\"..\"6\"" do
          @col.should == ("3".."7")
        end

        it "should == Col.new(3..6)" do
          @col.should == Col.new(3..7)
        end
      end
    end

    describe "#is_valid?" do
      it "returns true for 1" do
        Col.is_valid?(1).should be true
      end

      it "returns true for 10" do
        Col.is_valid?(10).should be true
      end

      it "returns false for 11" do
        Col.is_valid?(11).should be false
      end

      it "returns false for 0" do
        Col.is_valid?(0).should be false
      end

      it "returns false for \"A\"" do
        Col.is_valid?("A").should be false
      end

      it "returns false for \"C\"..\"E\"" do
        Col.is_valid?("C".."E").should be false
      end

      it "returns false for :D" do
        Col.is_valid?(:D).should be false
      end
    end
  end
end
