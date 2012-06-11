require 'spec_helper.rb'

module Rubaship
  describe Pos do
    it "accepts a string with a valid position" do
      Pos.new("C3:V").should == [:C, 3, :V]
    end

    it "accepts a sequence of Row, Col and Ori objects" do
      Pos.new(Row.new(:A), Col.new(3), Ori.new(:H)).should == [:A, 3, :H]
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
