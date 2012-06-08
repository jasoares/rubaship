require 'spec_helper.rb'

module Rubaship
  describe Row::ROWS do
    it "keeps a Symbol array of valid rows" do
      Row::ROWS.should == ("A".."J").to_a
    end
  end

  describe Row do
    it "accepts a Symbol" do
      Row.new(:D).should == :D
    end

    it "accepts a String" do
      Row.new("E").should == :E
    end

    it "accepts a zero_based Fixnum" do
      Row.new(3).should == :D
    end

    it "accepts a String Range" do
      Row.new("C".."E").should == (:C..:E)
    end

    it "accepts a Symbol Range" do
      Row.new(:D..:F).should == (:D..:F)
    end

    it "accepts a Row" do
      Row.new(Row.new(:B)).should == :B
    end

    context "for a sample Row created with the value :G" do
      before(:each) do
        @row = Row.new(:G)
      end

      describe "#range?" do
        it "returns false" do
          @row.range?.should be false
        end
      end

      describe "#size" do
        it "returns 1" do
          @row.size.should be 1
        end
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

      describe "#==" do
        it "should == 6" do
          @row.should == 6
        end

        it "should == :G" do
          @row.should == :G
        end

        it "should == \"G\"" do
          @row.should == "G"
        end

        it "should == Row.new(:G)" do
          @row.should == Row.new(:G)
        end
      end
    end

    context "for a sample row which is a range of rows :D..:G" do
      before(:each) do
        @row = Row.new(:D..:G)
      end

      describe "#range?" do
        it "returns true" do
          @row.range?.should be true
        end
      end

      describe "#size" do
        it "returns 4" do
          @row.size.should be 4
        end
      end

      describe "#to_idx" do
        it "returns 3..6" do
          @row.to_idx.should == (3..6)
        end
      end

      describe "#to_sym" do
        it "returns :D..:G" do
          @row.to_sym.should == (:D..:G)
        end
      end

      describe "#to_s" do
        it "returns \"D\"..\"G\"" do
          @row.to_s.should == ("D".."G")
        end
      end

      describe "#==" do
        it "should == 3..6" do
          @row.should == (3..6)
        end

        it "should == :D..:G" do
          @row.should == (:D..:G)
        end

        it "should == \"D\"..\"G\"" do
          @row.should == ("D".."G")
        end

        it "should == Row.new(:D..:G)" do
          @row.should == Row.new(:D..:G)
        end
      end
    end
  end
end
