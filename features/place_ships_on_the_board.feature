@place_ships @api @wip
Feature: place ships on the board

  As a player
  In order to start playing
  I need to place my ships on my board

  Ships are placed on each player's board by specifying an anchor
  position, and the orientation.

  The anchor position should be specified by a letter and a number and
  corresponds to the top left most position that the ship will ocupy.

  The placing of every ship must check that the ship fits in the board
  and that no other, already placed ship, is overlapped.

  If there is any break of the above constraints, the placing should
  aborted with an explanatory message.

  Scenario: empty board
    Given I have the board:
      |   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
      | A |   |   |   |   |   |   |   |   |   |   |
      | B |   |   |   |   |   |   |   |   |   |   |
      | C |   |   |   |   |   |   |   |   |   |   |
      | D |   |   |   |   |   |   |   |   |   |   |
      | E |   |   |   |   |   |   |   |   |   |   |
      | F |   |   |   |   |   |   |   |   |   |   |
      | G |   |   |   |   |   |   |   |   |   |   |
      | H |   |   |   |   |   |   |   |   |   |   |
      | I |   |   |   |   |   |   |   |   |   |   |
      | J |   |   |   |   |   |   |   |   |   |   |
    When I place my aircraft carrier at b3:h
    Then I should have the following board:
      |   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
      | A |   |   |   |   |   |   |   |   |   |   |
      | B |   |   | A | A | A | A | A |   |   |   |
      | C |   |   |   |   |   |   |   |   |   |   |
      | D |   |   |   |   |   |   |   |   |   |   |
      | E |   |   |   |   |   |   |   |   |   |   |
      | F |   |   |   |   |   |   |   |   |   |   |
      | G |   |   |   |   |   |   |   |   |   |   |
      | H |   |   |   |   |   |   |   |   |   |   |
      | I |   |   |   |   |   |   |   |   |   |   |
      | J |   |   |   |   |   |   |   |   |   |   |
    And my aircraft carrier should be placed
