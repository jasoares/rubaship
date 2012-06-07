require 'spec_helper.rb'

module Rubaship
  describe Col do
    it "accepts a non zero based Fixnum" do
      Col.new(1).should == 1
    end

    it "accepts a zero based Fixnum" do
      Col.new(2, true).should == 3
    end

    it "accepts a String with a non zero based number" do
      Col.new("3").should == 3
    end

    context "for a sample column created with the non zero based value 5" do
      before(:all) do
        @col = Col.new(5)
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

    describe ".cols" do
      it "returns an array of string columns with the size passed" do
        Col.cols(4).should == %w{ 1 2 3 4 }
      end

      it "returns an array of string columns with size 10 when no size is passed" do
        Col.cols.should == %w{ 1 2 3 4 5 6 7 8 9 10 }
      end
    end
  end
end
