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

        raw[1..10].collect do |table_row|
          table_row[1..10].collect do |table_cell|
            Rubaship::Ship.create(table_cell)
          end
        end
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