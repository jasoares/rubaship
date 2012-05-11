module Cucumber
  module Ast
    class Table
      def to_ships_hash
        validate_ship_table

        map_column!('size') { |size| size.to_i }

        hashes
      end
      def to_board
        validate_board_table

        map_column!("", true) { |char| char.to_sym }

        board = Hash.new do |hash, key|
          hash[key[0]] = key[1..10]
        end

        raw[1..10].each do |row|
          board[row]
        end
        board
      end

      def validate_board_table
        verify_table_width(11)

        ("1".."10").each { |col| verify_column(col) }

        ("A".."J").each { |row| verify_row(row) }
      end

      def validate_ship_table
        verify_table_width(2)
        ["aircraft carrier",
          "battleship",
          "submarine",
          "destroyer",
          "patrol boat"
        ].each { |row| verify_row(row) }

        ["name", "size"].each { |col| verify_column(col) }
      end

      def verify_row(row_name)
        row_headers = raw.collect { |row| row[0] }
        raise %{The row named "#{row_name}" does not exist} unless row_headers.include?(row_name)
      end
    end
  end
end