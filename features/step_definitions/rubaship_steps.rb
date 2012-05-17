SHIP_REGEXP = /aircraft carrier|battleship|destroyer|submarine|patrol boat/i

Given /^I have the board:$/ do |table|
  @player = Rubaship::Game.new.player
  @player.board.should == table.to_board
end

Given /^I have the player's list of ships$/ do
  @list = Rubaship::Game.new.player.ships
end

When /^I start a new game$/ do
  @game = Rubaship::Game.new
  @player = @game.player
end

When /^I ask for the (#{SHIP_REGEXP}) on that list$/ do |ship|
  @ship = @list[Rubaship::Ship.index(ship)]
end

When /^I enter (.*) as the location$/ do |location|
  @location = location
end

When /^I place my (#{SHIP_REGEXP}) at (.*)$/ do |ship, location|
  loc = Rubaship::Board.parse_location(location)
  @player.place(@player.ship(ship), loc)
end

Then /^I should get the player's (#{SHIP_REGEXP}) ship object$/ do |ship|
  ship = ship.split(" ").each { |word| word.capitalize! }.join
  @ship.should == @list[Rubaship::const_get(ship)::INDEX]
end

Then /^I should have the following ships:$/ do |table|
  ships = table.to_ships_hash.collect do |ship|
    Rubaship::Ship.new(ship['name'], ship['size'])
  end
  @player.ships.should == ships
end

Then /^my (#{SHIP_REGEXP}) should be placed at (.*)$/ do |ship, pos|
  @player.ship(ship).position.should == Rubaship::Board.parse_location(pos)
end

Then /^I should have the following board:$/ do |table|
  @player.board.should == table.to_board
end

Then /^I should see the message:$/ do |message|
  steps %{
    Then the output should match:
    """
    #{message}
    """
  }
end

Then /^it should mean ([A-J]|nil) ([1-9]|10|nil) (horizontal|vertical|nil)$/ do |row, col, ori|
  if row == "nil" or col == "nil" or ori == "nil"
    Rubaship::Board.parse_location(@location).should be_nil
  else
    Rubaship::Board.parse_location(@location).should == {
      :row => row.upcase.to_sym,
      :col => col.ord - '0'.ord - 1,
      :ori => ori[0].upcase.to_sym
    }
  end
end
