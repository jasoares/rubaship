require 'spec_helper.rb'

module Rubaship
  describe Row do
    it "accepts a Symbol" do
      Row.new(:D).to_idx.should be 3
    end

    it "accepts a String" do
      Row.new("E").to_idx.should be 4
    end

    it "accepts a zero_based Fixnum" do
      Row.new(3).to_idx.should be 3
    end

    it "accepts a Row" do
      Row.new(Row.new(:B)).to_idx.should be 1
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
  end
end