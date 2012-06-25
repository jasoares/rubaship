require 'spec_helper.rb'

module Rubaship
  module Cli
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
end