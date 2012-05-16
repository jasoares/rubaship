@specify_location @cli
Feature: player specifies location

  As a player playing on the cli client
  In order to be straight forward to place a ship
  I want to be able to specify a location in a simple short manner

  Taking into account that ships are placed on each player's board by
  specifying an anchor position, and that the location is given by a
  letter and a number of the board, and that the orientation is given
  by a horizontal ou vertical option, the following are the considerations
  about how the player should provide that information:

    * There is no mandatory order and the letter is not case sensitive.
      For example: A3, 4C, f7 or 9g

    * The orientation should be horizontal or vertical and can be expressed
      both as h and horizontal or v and vertical, also not case sensitive.
      The orientation always comes last and should be separated by a ":" (colon)
      from the position part. Any word partial of horizontal like horiz or of
      vertical like vert should be accepted as well, so the following examples
      are valid as well
        C3:horiz, C3:verti, A4:ver, F6:hor

    * So some possible full examples of the specified positions may be:
      a2:h, A2:h, 2A:horizontal, a2:H, A2:Horizontal, 2A:HORIZONTAL
      f8:v, F8:v, 8F:vertical, f8:V, F8:Vertical, 8F:VERTICAL

    * Yet a more ubiquitous accepted examples list:
      H6:h 6H:horizontal, h6:H, H8:Horizontal, 8H:H, 8H:HORIZONTAL

  There is, however, a standard format which will be used by the game to
  express locations wherever necessary which is the upcase, [row][col]:[ori]
  format.
    For example, A2 horizontal, H8 horizontal, B3 vertical and so on

  Scenario Outline: specifying location
    When I enter <input> as the location
    Then it should mean <anchor[row]> <anchor[col]> <orientation>

  Scenarios: valid input, standard order, capitalized
    | input           | anchor[row] | anchor[col] | orientation |
    | A7:H            |      A      |      7      | horizontal  |
    | F6:HORIZONTAL   |      F      |      6      | horizontal  |
    | G4:V            |      G      |      4      | vertical    |
    | H10:VERTICAL    |      H      |     10      | vertical    |

  Scenarios: valid input, standard order, lowercase
    | input           | anchor[row] | anchor[col] | orientation |
    | a5:h            |      A      |      5      | horizontal  |
    | c2:v            |      C      |      2      | vertical    |
    | d3:horizontal   |      D      |      3      | horizontal  |
    | G10:vertical    |      G      |     10      | vertical    |

  Scenarios: valid input, standard order, mixed
    | input           | anchor[row] | anchor[col] | orientation |
    | A2:v            |      A      |      2      | vertical    |
    | d4:H            |      D      |      4      | horizontal  |
    | J9:Vertical     |      J      |      9      | vertical    |
    | g8:Horizontal   |      G      |      8      | horizontal  |
    | F10:HoRiZONtal  |      F      |     10      | horizontal  |

  Scenarios: valid input, reversed order, mixed
    | input           | anchor[row] | anchor[col] | orientation |
    | 3A:v            |      A      |      3      | vertical    |
    | 10F:Horizon     |      F      |     10      | horizontal  |
    | 10G:VERT        |      G      |     10      | vertical    |

  Scenarios: valid input, edge cases
    | input           | anchor[row] | anchor[col] | orientation |
    | A1:ver          |      A      |      1      | vertical    |
    | J10:vert        |      J      |     10      | vertical    |
    | A10:HO          |      A      |     10      | horizontal  |
    | 3A:ve           |      A      |      3      | vertical    |
    | B3:ho           |      B      |      3      | horizontal  |

  Scenarios: invalid input
    | input           | anchor[row] | anchor[col] | orientation |
    | 0F:h            |     nil     |     nil     | nil         |
    | C0:v            |     nil     |     nil     | nil         |
    | 7G v            |     nil     |     nil     | nil         |
    | K3:V            |     nil     |     nil     | nil         |
    | 3K:V            |     nil     |     nil     | nil         |
    | 11G:H           |     nil     |     nil     | nil         |
    | 3A:verical      |     nil     |     nil     | nil         |
    | 10F:Horzontal   |     nil     |     nil     | nil         |
    | B3:hr           |     nil     |     nil     | nil         |
    | K3:vt           |     nil     |     nil     | nil         |
    | K3:vrt          |     nil     |     nil     | nil         |
