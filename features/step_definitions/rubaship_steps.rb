SHIP_REGEXP = /aircraft carrier|battleship|destroyer|submarine|patrol boat/i

Given /^I have the board:$/ do |table|
  @player = Rubaship::Game.new.player
  @player.board.should == table.to_board
end

Given /^I have the player's list of ships$/ do
  @list = Rubaship::Game.new.player.ships
end

Given /^I have a board already setup with my fleet$/ do
  @game = Rubaship::Game.new
  @player = @game.player
  @board = @player.board
  @board.add!(@player.ship(:A), :B, 2, :H)
  @board.add!(@player.ship(:B), :D, 3, :V)
  @board.add!(@player.ship(:D), :D, 6, :H)
  @board.add!(@player.ship(:S), :F, 10, :V)
  @board.add!(@player.ship(:P), :J, 6, :H)
end

When /^I start a new game$/ do
  @game = Rubaship::Game.new
  @player = @game.player
end

When /^I ask for the (#{SHIP_REGEXP}) on that list$/ do |ship|
  @ship = @list[Rubaship::Ship.index(ship)]
end

When /^I enter (.*) as the position$/ do |pos|
  @pos = pos
end

When /^I place my (#{SHIP_REGEXP}) at (.*)$/ do |ship, pos|
  p = Rubaship::Board.parse_pos(pos)
  begin
    @player.place(ship, p)
  rescue Exception => e
    @message = e.message
  end
end

When /^I use the default values$/ do
end

When /^I (?:use|set|select|choose) "?([^"]{0,2}|\d)(?: spaces)?"? as the ((?:empty|separator|column) (?:character|width))$/ do |arg, type|
  case type
    when /empty character/     then @empty     = arg
    when /separator character/ then @sep       = arg
    when /column width/        then @col_width = arg.ord - '0'.ord
  end
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
  @player.ship(ship).position.should == Rubaship::Board.parse_pos(pos)
end

Then /^my (#{SHIP_REGEXP}) should not be placed$/ do |ship|
  @player.ship(ship).placed?.should be false
end

Then /^I should have the following board:$/ do |table|
  @player.board.should == table.to_board
end

Then /^I should see the following representation:$/ do |representation|
  empty = @empty.nil? ? " " : @empty
  sep = @sep.nil? ? "|" : @sep
  col_width = @col_width.nil? ? 3 : @col_width
  @board.to_s(empty, sep, col_width).should == representation
end

Then /^I should see the message:$/ do |message|
  @message.should == message
end

Then /^it should mean ([A-J]|nil) ([1-9]|10|nil) (horizontal|vertical|nil)$/ do |row, col, ori|
  if row == "nil" or col == "nil" or ori == "nil"
    Rubaship::Board.parse_pos(@pos).should be_nil
  else
    Rubaship::Board.parse_pos(@pos).should == Rubaship::Board.format_pos(row, col, ori)
  end
end
