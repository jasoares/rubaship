@welcome_msg @cli
Feature: welcome message

  In order to get some feedback
  As a player
  I want to see a welcome message when I start the game

  Scenario: initiate the game
    When I run `rubaship`
    Then the output should match:
      """
      ########################################
      #                                      #
      #         Welcome to Rubaship!         #
      #                                      #
      ########################################
      """