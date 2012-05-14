@ship_index @api
Feature: ship index support

  As a developer
  In order to be able to access individual ships inside array grouped ships
  I want to extablish an order and to provide a fixed index helper method
  So that I can improve my api and its business value

  In the classic battleship game the ships must be placed on the board.
  The player should be walked through that process and make it as easy as
  possible. Since when the board is empty, the task of placing big ships
  is less prone to location and collision issues the order of placing ships
  should be:
    aircraft carrier > battleship > submarine > destroyer > patrol boat

  Since we have this order, we will base the indexing of ships in lists, like
  the player ship's list on this order.

  Scenario: index ships on lists
    Given I have the player's list of ships
    When I ask for the aircraft carrier on that list
    Then I should get the player's aircraft carrier ship object