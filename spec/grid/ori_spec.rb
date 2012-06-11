require 'spec_helper.rb'

module Rubaship
  describe Ori do
    it "accepts a full word \"horizontal\"" do
      Ori.new("horizontal").should == :H
    end

    it "accepts a full word \"vertical\"" do
      Ori.new("vertical").should == :V
    end

    it "accepts a partial word \"horiz\"" do
      Ori.new("horiz").should == :H
    end

    it "accepts a partial word \"vert\"" do
      Ori.new("vert").should == :V
    end

    it "accepts the initial letter of the word 'h'" do
      Ori.new("h").should == :H
    end

    it "accepts the initial letter of the word 'v'" do
      Ori.new("v").should == :V
    end

    it "raises an InvalidOriArgument when passed \"vr\"" do
      lambda { Ori.new("vr") }.should raise_error(InvalidOriArgument)
    end

    it "raises an InvalidOriArgument when passed \"hr\"" do
      lambda { Ori.new("hr") }.should raise_error(InvalidOriArgument)
    end

    it "accepts the full word Symbol :HORIZONTAL" do
      Ori.new(:HORIZONTAL).should == :H
    end

    it "accepts a partial word :Horiz" do
      Ori.new(:Horiz).should == :H
    end

    it "accepts the full word Symbol :vertical" do
      Ori.new(:vertical).should == :V
    end

    it "accepts a partial word :Vertic" do
      Ori.new(:Vertic).should == :V
    end

    it "accepts the initial letter of the word :H" do
      Ori.new(:H).should == :H
    end

    it "raises an InvalidOriArgument when passed the symbol :HZ" do
      lambda { Ori.new(:HZ) }.should raise_error(InvalidOriArgument)
    end

    it "raises an InvalidOriArgument when a non valid type is passed" do
      lambda { Ori.new(4) }.should raise_error(InvalidOriArgument)
    end

    context "for a sample horizontal Ori" do
      before(:each) do
        @ori = Ori.new(:H)
      end

      describe "#horiz?" do
        it "returns true" do
          @ori.horiz?.should be true
        end
      end

      describe "#to_sym" do
        it "returns :H" do
          @ori.to_sym.should == :H
        end
      end

      describe "#to_s" do
        it "returns \"horizontal\"" do
          @ori.to_s.should == "horizontal"
        end
      end

      describe "#vert?" do
        it "returns false" do
          @ori.vert?.should be false
        end
      end

      describe "#==" do
        it "returns true when passed :H" do
          @ori.should == :H
        end

        it "returns true when passed \"H\"" do
          @ori.should == "H"
        end

        it "returns true when passed :Horiz" do
          @ori.should == :Horiz
        end

        it "returns true when passed \"Horiz\"" do
          @ori.should == "Horiz"
        end

        it "returns true when passed :Horizontal" do
          @ori.should == :Horizontal
        end
      end
    end


    context "for a sample vertical Ori" do
      before(:each) do
        @ori = Ori.new(:V)
      end

      describe "#horiz?" do
        it "returns false" do
          @ori.horiz?.should be false
        end
      end

      describe "#to_sym" do
        it "returns :H" do
          @ori.to_sym.should == :V
        end
      end

      describe "#to_s" do
        it "returns \"vertical\"" do
          @ori.to_s.should == "vertical"
        end
      end

      describe "#vert?" do
        it "returns true" do
          @ori.vert?.should be true
        end
      end

      describe "#==" do
        it "returns true when passed :V" do
          @ori.should == :V
        end

        it "returns true when passed \"V\"" do
          @ori.should == "V"
        end

        it "returns true when passed :Vert" do
          @ori.should == :Vert
        end

        it "returns true when passed \"Vert\"" do
          @ori.should == "Vert"
        end

        it "returns true when passed :Vertical" do
          @ori.should == :Vertical
        end
      end
    end

    describe "is_valid?" do
      it "returns true for \"horiz\"" do
        Ori.is_valid?("horiz").should be true
      end

      it "returns true for \"h\"" do
        Ori.is_valid?("h").should be true
      end

      it "returns true for \"HoRiZon\"" do
        Ori.is_valid?("HoRiZon").should be true
      end

      it "returns false for \"Hz\"" do
        Ori.is_valid?("Hz").should be false
      end

      it "returns true for \"Vertical\"" do
        Ori.is_valid?("Vertical").should be true
      end

      it "returns true for \"Ver\"" do
        Ori.is_valid?("Ver").should be true
      end

      it "returns false for \"Vr\"" do
        Ori.is_valid?("Vr").should be false
      end
    end
  end
end
