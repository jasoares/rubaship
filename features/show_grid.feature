@grid_view, @api
Feature: show grid

  As a player using the CLI client
  In order to see the current state of my grid
  I want to be able to see a properly formatted text representation of it

  The grid may be exported to a properly formatted string using different
  options, which are:
    * empty sector character (default " ")
    * separator character    (default "|")
    * column width           (default 3)

  Background:
    Given I have a grid already setup with my fleet

  Scenario: default representation
    When I use the default values
    Then I should see the following representation:
      """
      |   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |
      | A |   |   |   |   |   |   |   |   |   |   |
      | B |   | A | A | A | A | A |   |   |   |   |
      | C |   |   |   |   |   |   |   |   |   |   |
      | D |   |   | B |   |   | D | D | D |   |   |
      | E |   |   | B |   |   |   |   |   |   |   |
      | F |   |   | B |   |   |   |   |   |   | S |
      | G |   |   | B |   |   |   |   |   |   | S |
      | H |   |   |   |   |   |   |   |   |   | S |
      | I |   |   |   |   |   |   |   |   |   |   |
      | J |   |   |   |   |   | P | P |   |   |   |

      """

  Scenario: 1 column width
    When I set 1 spaces as the column width
    Then I should see the following representation:
      """
      | |1|2|3|4|5|6|7|8|9|10|
      |A| | | | | | | | | | |
      |B| |A|A|A|A|A| | | | |
      |C| | | | | | | | | | |
      |D| | |B| | |D|D|D| | |
      |E| | |B| | | | | | | |
      |F| | |B| | | | | | |S|
      |G| | |B| | | | | | |S|
      |H| | | | | | | | | |S|
      |I| | | | | | | | | | |
      |J| | | | | |P|P| | | |

      """

  Scenario: 2 column width
    When I select 2 spaces as the column width
    Then I should see the following representation:
      """
      |  |1 |2 |3 |4 |5 |6 |7 |8 |9 |10|
      |A |  |  |  |  |  |  |  |  |  |  |
      |B |  |A |A |A |A |A |  |  |  |  |
      |C |  |  |  |  |  |  |  |  |  |  |
      |D |  |  |B |  |  |D |D |D |  |  |
      |E |  |  |B |  |  |  |  |  |  |  |
      |F |  |  |B |  |  |  |  |  |  |S |
      |G |  |  |B |  |  |  |  |  |  |S |
      |H |  |  |  |  |  |  |  |  |  |S |
      |I |  |  |  |  |  |  |  |  |  |  |
      |J |  |  |  |  |  |P |P |  |  |  |

      """

  Scenario: 5 column width
    When I use 5 spaces as the column width
    Then I should see the following representation:
      """
      |     |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  | 10  |
      |  A  |     |     |     |     |     |     |     |     |     |     |
      |  B  |     |  A  |  A  |  A  |  A  |  A  |     |     |     |     |
      |  C  |     |     |     |     |     |     |     |     |     |     |
      |  D  |     |     |  B  |     |     |  D  |  D  |  D  |     |     |
      |  E  |     |     |  B  |     |     |     |     |     |     |     |
      |  F  |     |     |  B  |     |     |     |     |     |     |  S  |
      |  G  |     |     |  B  |     |     |     |     |     |     |  S  |
      |  H  |     |     |     |     |     |     |     |     |     |  S  |
      |  I  |     |     |     |     |     |     |     |     |     |     |
      |  J  |     |     |     |     |     |  P  |  P  |     |     |     |

      """

  Scenario: "#" as the separator character
    When I set "#" as the separator character
    Then I should see the following representation:
      """
      #   # 1 # 2 # 3 # 4 # 5 # 6 # 7 # 8 # 9 #10 #
      # A #   #   #   #   #   #   #   #   #   #   #
      # B #   # A # A # A # A # A #   #   #   #   #
      # C #   #   #   #   #   #   #   #   #   #   #
      # D #   #   # B #   #   # D # D # D #   #   #
      # E #   #   # B #   #   #   #   #   #   #   #
      # F #   #   # B #   #   #   #   #   #   # S #
      # G #   #   # B #   #   #   #   #   #   # S #
      # H #   #   #   #   #   #   #   #   #   # S #
      # I #   #   #   #   #   #   #   #   #   #   #
      # J #   #   #   #   #   # P # P #   #   #   #

      """

  Scenario: "[]" as the separator character
    When I choose "[]" as the separator character
    Then I should see the following representation:
      """
      []   [] 1 [] 2 [] 3 [] 4 [] 5 [] 6 [] 7 [] 8 [] 9 []10 []
      [] A []   []   []   []   []   []   []   []   []   []   []
      [] B []   [] A [] A [] A [] A [] A []   []   []   []   []
      [] C []   []   []   []   []   []   []   []   []   []   []
      [] D []   []   [] B []   []   [] D [] D [] D []   []   []
      [] E []   []   [] B []   []   []   []   []   []   []   []
      [] F []   []   [] B []   []   []   []   []   []   [] S []
      [] G []   []   [] B []   []   []   []   []   []   [] S []
      [] H []   []   []   []   []   []   []   []   []   [] S []
      [] I []   []   []   []   []   []   []   []   []   []   []
      [] J []   []   []   []   []   [] P [] P []   []   []   []

      """

  Scenario: mixed parameters
    When I set "~" as the empty character
     And I use "H" as the separator character
     And I choose 5 spaces as the column width
    Then I should see the following representation:
      """
      H  ~  H  1  H  2  H  3  H  4  H  5  H  6  H  7  H  8  H  9  H 10  H
      H  A  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H
      H  B  H  ~  H  A  H  A  H  A  H  A  H  A  H  ~  H  ~  H  ~  H  ~  H
      H  C  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H
      H  D  H  ~  H  ~  H  B  H  ~  H  ~  H  D  H  D  H  D  H  ~  H  ~  H
      H  E  H  ~  H  ~  H  B  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H
      H  F  H  ~  H  ~  H  B  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  S  H
      H  G  H  ~  H  ~  H  B  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  S  H
      H  H  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  S  H
      H  I  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H  ~  H
      H  J  H  ~  H  ~  H  ~  H  ~  H  ~  H  P  H  P  H  ~  H  ~  H  ~  H

      """

  Scenario: other mixed arguments
    When I set "." as the empty character
     And I use "" as the separator character
     And I choose 3 spaces as the column width
    Then I should see the following representation:
      """
       .  1  2  3  4  5  6  7  8  9 10 
       A  .  .  .  .  .  .  .  .  .  . 
       B  .  A  A  A  A  A  .  .  .  . 
       C  .  .  .  .  .  .  .  .  .  . 
       D  .  .  B  .  .  D  D  D  .  . 
       E  .  .  B  .  .  .  .  .  .  . 
       F  .  .  B  .  .  .  .  .  .  S 
       G  .  .  B  .  .  .  .  .  .  S 
       H  .  .  .  .  .  .  .  .  .  S 
       I  .  .  .  .  .  .  .  .  .  . 
       J  .  .  .  .  .  P  P  .  .  . 

      """
