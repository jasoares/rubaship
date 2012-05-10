require 'spec_helper.rb'

module Rubaship
  describe Cli do
    describe "#start" do
      it "returns a welcome message to the player" do
        Cli.start.should == <<-EOF
########################################
#                                      #
#         Welcome to Rubaship!         #
#                                      #
########################################
        EOF
      end
    end
  end
end