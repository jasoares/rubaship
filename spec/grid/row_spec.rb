require 'spec_helper.rb'

module Rubaship
  describe Row do
    it "accepts a Symbol" do
      Row.new(:D).should == 3
    end

    it "accepts a String" do
      Row.new("E").should == 4
    end

    it "accepts a zero_based Fixnum" do
      Row.new(3).should == 3
    end

    it "accepts a Row" do
      Row.new(Row.new(:B)).should == 1
    end

    context "for a sample Row created with the value :G" do
      before(:each) do
        @row = Row.new(:G)
      end

      describe "#to_idx" do
        it "returns 6" do
          @row.to_idx.should be 6
        end
      end

      describe "#to_sym" do
        it "returns :G" do
          @row.to_sym.should == :G
        end
      end

      describe "#to_s" do
        it "returns \"G\"" do
          @row.to_s.should == "G"
        end
      end
    end

    describe ".rows" do
      it "returns an array of string rows with the given size" do
        Row.rows(4).should == %w{ A B C D }
      end

      it "returns an array of string rows with size 10 when no size is passed" do
        Row.rows.should == %w{ A B C D E F G H I J }
      end
    end
  end
end
