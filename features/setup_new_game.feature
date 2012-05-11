@setup_game @api @wip
Feature: setup new game

  As a player
  In order to play battleship
  I need to setup the game

  The classic battleship game has 5 ships with its respective
  sizes which correspond to its initial life status.

  Each ship is represented on the board by the initial letter of its name.

  The player has two boards, the fleet board, where the players places his
  ships, and the war board where the he keeps track of its shots.

  Each player's fleet board corresponds to the opponent's war board without the
  ability to see the ships but only the shots taken.

  Scenario: starting a new game
    When I start a new game
    Then I should have the following ships:
      | name             | size |
      | aircraft carrier |  5   |
      | battleship       |  4   |
      | submarine        |  3   |
      | destroyer        |  3   |
      | patrol boat      |  2   |
    And I should have the following fleet board:
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
