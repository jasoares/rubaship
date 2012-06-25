module Rubaship
  module Grid
    class Sector

      attr_accessor :ship

      def initialize(ship=nil)
        @ship = ship
      end

      def initialize_copy(orig)
        @ship = orig.ship.is_a?(Ship) ? orig.ship.dup : nil
      end

      def ==(o)
        case o
          when Hash then to_hash == o
          else @ship == o.ship
        end
      end

      def ship=(ship)
        if @ship.nil?
          @ship = ship
        else
          raise OverlapShipError.new(@ship)
        end
      end

      def to_hash
        { :ship => @ship }
      end

      def to_s(empty=" ")
        @ship.nil? ? empty : @ship.to_s
      end
    end
  end
end
