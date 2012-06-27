module Rubaship
  module Grid
    class InvalidRowArgument < ArgumentError
      def initialize(row)
        super("Invalid row or range type passed #{row}:#{row.class}")
      end
    end

    class InvalidColArgument < ArgumentError
      def initialize(col)
        super("Invalid column or range type passed #{col}:#{col.class}")
      end
    end

    class InvalidOriArgument < ArgumentError
      def initialize(ori)
        super("Invalid orientation type passed #{ori}:#{ori.class}")
      end
    end

    class InvalidPositionArgument < ArgumentError
      def initialize
        super("Either row or col must be a Range matching the orientation argument if any.")
      end
    end
  end
end