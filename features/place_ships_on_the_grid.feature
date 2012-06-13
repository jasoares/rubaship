@place_ships @api
Feature: place ships on the grid

  As a player
  In order to start playing
  I need to place my ships on my grid

  Ships are placed on each player's grid by specifying an anchor
  position, and the orientation.

  The anchor position should be specified by a letter and a number and
  corresponds to the top left most position that the ship will ocupy.

  The placing of every ship must check that the ship fits in the grid
  and that no other, already placed ship, is overlapped.

  If there is any break of the above constraints, the placing should
  aborted with an explanatory message.

  Scenario: empty grid
    Given I have the grid:
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
    Then my aircraft carrier should be placed at B3:H
    And I should have the following grid:
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
    When I place my battleship at 9b:v
    Then my battleship should be placed at B9:V
    And I should have the following grid:
      |   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
      | A |   |   |   |   |   |   |   |   |   |   |
      | B |   |   | A | A | A | A | A |   | B |   |
      | C |   |   |   |   |   |   |   |   | B |   |
      | D |   |   |   |   |   |   |   |   | B |   |
      | E |   |   |   |   |   |   |   |   | B |   |
      | F |   |   |   |   |   |   |   |   |   |   |
      | G |   |   |   |   |   |   |   |   |   |   |
      | H |   |   |   |   |   |   |   |   |   |   |
      | I |   |   |   |   |   |   |   |   |   |   |
      | J |   |   |   |   |   |   |   |   |   |   |
    When I place my submarine at C5:V
    Then my submarine should be placed at C5:V
    And I should have the following grid:
      |   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
      | A |   |   |   |   |   |   |   |   |   |   |
      | B |   |   | A | A | A | A | A |   | B |   |
      | C |   |   |   |   | S |   |   |   | B |   |
      | D |   |   |   |   | S |   |   |   | B |   |
      | E |   |   |   |   | S |   |   |   | B |   |
      | F |   |   |   |   |   |   |   |   |   |   |
      | G |   |   |   |   |   |   |   |   |   |   |
      | H |   |   |   |   |   |   |   |   |   |   |
      | I |   |   |   |   |   |   |   |   |   |   |
      | J |   |   |   |   |   |   |   |   |   |   |

  @wip
  Scenario: ship out of grid
    Given I have the grid:
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
    When I place my aircraft carrier at G8:H
    Then my aircraft carrier should not be placed
     And I should see the message:
     """
     The aircraft carrier does not fit inside the grid if placed in G8:H.
     """
     And I should have the following grid:
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

  @wip
  Scenario: ship overlapping another ship
    Given I have the grid:
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
    When I place my aircraft carrier at E4:H
    Then my aircraft carrier should be placed at E4:H
     And I should have the following grid:
      |   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
      | A |   |   |   |   |   |   |   |   |   |   |
      | B |   |   |   |   |   |   |   |   |   |   |
      | C |   |   |   |   |   |   |   |   |   |   |
      | D |   |   |   |   |   |   |   |   |   |   |
      | E |   |   |   | A | A | A | A | A |   |   |
      | F |   |   |   |   |   |   |   |   |   |   |
      | G |   |   |   |   |   |   |   |   |   |   |
      | H |   |   |   |   |   |   |   |   |   |   |
      | I |   |   |   |   |   |   |   |   |   |   |
      | J |   |   |   |   |   |   |   |   |   |   |
    When I place my battleship at D6:V
    Then my battleship should not be placed
     And I should see the message:
     """
     Overlapping already positioned ship "aircraft carrier".
     """
     And I should have the following grid:
      |   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
      | A |   |   |   |   |   |   |   |   |   |   |
      | B |   |   |   |   |   |   |   |   |   |   |
      | C |   |   |   |   |   |   |   |   |   |   |
      | D |   |   |   |   |   |   |   |   |   |   |
      | E |   |   |   | A | A | A | A | A |   |   |
      | F |   |   |   |   |   |   |   |   |   |   |
      | G |   |   |   |   |   |   |   |   |   |   |
      | H |   |   |   |   |   |   |   |   |   |   |
      | I |   |   |   |   |   |   |   |   |   |   |
      | J |   |   |   |   |   |   |   |   |   |   |
    When I place my battleship at E2:H
    Then my battleship should not be placed
     And I should see the message:
     """
     Overlapping already positioned ship "aircraft carrier".
     """
     And I should have the following grid:
      |   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
      | A |   |   |   |   |   |   |   |   |   |   |
      | B |   |   |   |   |   |   |   |   |   |   |
      | C |   |   |   |   |   |   |   |   |   |   |
      | D |   |   |   |   |   |   |   |   |   |   |
      | E |   |   |   | A | A | A | A | A |   |   |
      | F |   |   |   |   |   |   |   |   |   |   |
      | G |   |   |   |   |   |   |   |   |   |   |
      | H |   |   |   |   |   |   |   |   |   |   |
      | I |   |   |   |   |   |   |   |   |   |   |
      | J |   |   |   |   |   |   |   |   |   |   |
