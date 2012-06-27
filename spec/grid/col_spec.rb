require 'spec_helper.rb'

module Rubaship
  module Grid
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

      context "for a sample column created with the non zero based value 7" do
        before(:each) do
          @col = Col.new(7)
        end

        describe "#eql?" do
          it "should eql Col.new(7)" do
            @col.should eql Col.new(7)
          end

          it "should not eql 7" do
            @col.should_not eql 7
          end
        end

        describe "#range?" do
          it "returns false" do
            @col.range?.should be false
          end
        end

        describe "#rangify!" do
          it "returns a col" do
            @col.rangify!(4).should be_a Col
          end

          it "returns 7..10 when passed a size of 4" do
            @col.rangify!(4).should eql Col.new(7..10)
          end
        end

        describe "#size" do
          it "returns 1" do
            @col.size.should be 1
          end
        end

        describe "#to_idx" do
          it "returns 6" do
            @col.to_idx.should be 6
          end
        end

        describe "#to_s" do
          it "returns \"7\"" do
            @col.to_s.should == "7"
          end
        end

        describe "#to_str" do
          it "returns \"7\"" do
            @col.to_str.should == "7"
          end
        end

        describe "#to_i" do
          it "returns 7" do
            @col.to_i.should be 7
          end
        end

        describe "#valid?" do
          it "returns true when passed a Battleship" do
            @col.valid?(Ship.create(:B)).should be true
          end

          it "returns true when passed 4" do
            @col.valid?(4).should be true
          end

          it "returns false when passed an Aircraft Carrier" do
            @col.valid?(Ship.create(:A)).should be false
          end

          it "returns false when passed 5" do
            @col.valid?(5).should be false
          end
        end

        describe "#==" do
          it "should == 7" do
            @col.should == 7
          end

          it "should == \"7\"" do
            @col.should == "7"
          end

          it "should == Col.new(7)" do
            @col.should == Col.new(7)
          end
        end
      end

      context "for a sample column which is the range of columns 3..7" do
        before(:each) do
          @col = Col.new(3..7)
        end

        describe "#eql?" do
          it "should eql Col.new(3..7)" do
            @col.should eql Col.new(3..7)
          end

          it "should not eql (3..7)" do
            @col.should_not eql (3..7)
          end
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
          it "returns \"3..7\"" do
            @col.to_s.should == "3..7"
          end
        end

        describe "#to_str" do
          it "returns \"3\"..\"7\"" do
            @col.to_str.should == ("3".."7")
          end
        end

        describe "#to_i" do
          it "returns 3..7" do
            @col.to_i.should == (3..7)
          end
        end

        describe "#valid?" do
          it "returns true when passed 5" do
            @col.valid?(5).should be true
          end

          it "returns true when passed an aircraft carrier" do
            @col.valid?(Ship.create(:A)).should be true
          end

          it "returns false when passed 6" do
            @col.valid?(6).should be false
          end
        end

        describe "#==" do
          it "should == 3..7" do
            @col.should == (3..7)
          end

          it "should == \"3\"..\"7\"" do
            @col.should == ("3".."7")
          end

          it "should == Col.new(3..7)" do
            @col.should == Col.new(3..7)
          end
        end
      end

      describe "::COLS" do
        it "keeps a String array of valid columns" do
          Col::COLS.should == ("1".."10").to_a
        end
      end

      describe ".is_valid?" do
        it "returns true for 1" do
          Col.is_valid?(1).should be true
        end

        it "returns true for 10" do
          Col.is_valid?(10).should be true
        end

        it "returns true when passed \"10\"" do
          Col.is_valid?("10").should be true
        end

        it "returns true when passed 4..6" do
          Col.is_valid?(4..6).should be true
        end

        it "returns true when passed \"4\"..\"6\"" do
          Col.is_valid?("4".."6").should be true
        end

        it "returns false for 11" do
          Col.is_valid?(11).should be false
        end

        it "returns false for 0" do
          Col.is_valid?(0).should be false
        end

        it "returns false when passed \"11\"" do
          Col.is_valid?("11").should be false
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

        it "returns false when passed \"7\"..\"11\"" do
          Col.is_valid?("7".."11").should be false
        end

        it "returns false when passed \"7..9\"" do
          Col.is_valid?("7..9").should be false
        end
      end
    end
  end
end
