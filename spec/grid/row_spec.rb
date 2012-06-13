require 'spec_helper.rb'

module Rubaship
  describe Row do
    it "accepts a Symbol" do
      Row.new(:D).should == :D
    end

    it "accepts a String" do
      Row.new("E").should == :E
    end

    it "accepts a lower case String" do
      Row.new("e").should == :E
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

    it "raises an InvalidRowArgument error when passed :K" do
      lambda { Row.new(:K) }.should raise_error(
        InvalidRowArgument,
        /^Invalid row or range type passed .+$/
      )
    end

    context "for a sample Row created with the value :G" do
      before(:each) do
        @row = Row.new(:G)
      end

      subject { @row }

      it { should respond_to(:length) }

      describe "#range?" do
        it "returns false" do
          @row.range?.should be false
        end
      end

      describe "#rangify!" do
        it "returns :G..:J when passed a size of 4" do
          @row.rangify!(4).should == (:G..:J)
        end

        it "changes the return value of range? from false to true" do
          lambda {
            @row.rangify!(3)
          }.should change(@row, :range?).from(false).to(true)
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

      describe "#valid?" do
        it "returns true when passed a Battleship" do
          @row.valid?(Ship.create(:B)).should be true
        end

        it "returns false when passed an Aircraft Carrier" do
          @row.valid?(Ship.create(:A)).should be false
        end

        it "returns false when passed 5" do
          @row.valid?(5).should be false
        end
      end

      describe "#==" do
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

      subject { @row }

      it { should respond_to(:length) }

      describe "#range?" do
        it "returns true" do
          @row.range?.should be true
        end
      end

      describe "#rangify!" do
        it "returns false to indicate it is already a Range" do
          @row.rangify!(4).should be false
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
        it "returns \"D..G\"" do
          @row.to_s.should == "D..G"
        end
      end

      describe "#to_str" do
        it "returns \"D\"..\"G\"" do
          @row.to_str.should == ("D".."G")
        end
      end

      describe "#valid?" do
        it "returns true when passed 4" do
          @row.valid?(4).should be true
        end

        it "returns true when passed a battleship" do
          @row.valid?(Ship.create(:B)).should be true
        end

        it "returns false when passed 5" do
          @row.valid?(5).should be false
        end

        it "returns false when passed an aircraft carrier" do
          @row.valid?(Ship.create(:A)).should be false
        end
      end

      describe "#==" do
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

    describe "::ROWS" do
      it "keeps a Symbol array of valid rows" do
        Row::ROWS.should == ("A".."J").to_a
      end
    end

    describe ".is_valid?" do
      it "returns true for \"A\"" do
        Row.is_valid?("A").should be true
      end

      it "returns true for \"a\"" do
        Row.is_valid?("a").should be true
      end

      it "returns false for 1" do
        Row.is_valid?(1).should be false
      end

      it "returns false for 0" do
        Row.is_valid?(0).should be false
      end
    end
  end
end
