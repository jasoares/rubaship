When /^I start a new game$/ do
  @game = Rubaship::Game.new
  @player = @game.player
end

Then /^I should have the following ships:$/ do |table|
  ships = table.to_ships_hash.inject([]) do |ships, s|
    ships << Rubaship::Ship.new(s['name'], s['size'])
  end
  @player.ships.should == ships
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
