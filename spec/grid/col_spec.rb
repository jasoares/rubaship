require 'spec_helper.rb'

module Rubaship
  describe Col do
    it "accepts a column number based Fixnum" do
      Col.new(1).should == 1
    end

    it "accepts a String with a column number" do
      Col.new("9").should == 9
    end

    it "accepts a column number based Fixnum Range" do
      Col.new(4..6).should == (4..6)
    end

    it "accepts a String Range with column numbers" do
      Col.new("3".."6").should == (3..6)
    end

    context "for a sample column created with the non zero based value 5" do
      before(:all) do
        @col = Col.new(5)
      end

      describe "#range?" do
        it "returns false" do
          @col.range?.should be false
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
      before(:all) do
        @col = Col.new(3..7)
      end

      describe "#range?" do
        it "returns true" do
          @col.range?.should be true
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

    describe ".cols" do
      it "returns an array of string columns with the size passed" do
        Col.cols(4).should == %w{ 1 2 3 4 }
      end

      it "returns an array of string columns with size 10 when no size is passed" do
        Col.cols.should == ("1".."26").to_a
      end
    end
  end
end
