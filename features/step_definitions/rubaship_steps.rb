SHIP_REGEXP = /aircraft carrier|battleship|destroyer|submarine|patrol boat/i

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

Then /^my (#{SHIP_REGEXP}) should be (.*)$/ do |ship, method|
  method.gsub!(" ", "_").to_sym
  @player.ships[Ship.index(ship)].should be method
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
