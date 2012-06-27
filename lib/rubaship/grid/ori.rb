module Rubaship
  module Grid
    class Ori

      Horiz = "horizontal"
      Vert = "vertical"

      attr_reader :ori

      def initialize(ori)
        raise InvalidOriArgument.new(ori) unless Ori.is_valid? ori
        @ori = Ori.to_sym(ori)
      end

      def eql?(o)
        o.is_a? Ori and self == o
      end

      def horiz?
        ori == :H
      end

      alias :to_pos :ori

      def to_s
        case ori
          when :H then Horiz[0].upcase
          when :V then Vert[0].upcase
        end
      end

      alias :to_sym :ori

      def vert?
        ori == :V
      end

      def ==(o)
        ori == Ori.to_sym(o)
      end

      def self.to_sym(ori)
        case ori
          when String
            if    /#{ori}\w*/i.match(Horiz) then :H
            elsif /#{ori}\w*/i.match(Vert)  then :V
            end
          when Symbol then Ori.to_sym(ori.to_s)
          when Ori    then ori.to_sym
        end
      end

      def self.format(str)
        Ori.new(str).to_sym
      end

      def self.is_valid?(str)
        Ori.to_sym(str) ? true : false
      end
    end
  end
end
