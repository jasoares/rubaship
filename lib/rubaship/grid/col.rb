module Rubaship
  module Grid
    class Col

      COLS = ("1".."10").to_a

      def initialize(v)
        raise InvalidColArgument.new v unless Col.is_valid? v
        @idx = Col.to_idx v
      end

      def eql?(o)
        o.is_a? Col and self == o
      end

      def range?
        @idx.is_a?(Range)
      end

      def rangify!(s)
        s = s.size if s.respond_to? :length
        return false if self.range? or !Col.is_valid?(@idx + s)
        @idx = (@idx..@idx + s - 1)
        self
      end

      def size
        self.range? ? @idx.count : 1
      end

      def to_i
        self.range? ? (@idx.min + 1)..(@idx.max + 1) : @idx + 1
      end

      def to_idx
        @idx
      end

      def to_pos
        self.to_i
      end

      def to_s
        self.to_i.to_s
      end

      def to_str
        self.range? ? self.to_i.min.to_s..self.to_i.max.to_s : self.to_i.to_s
      end

      def valid?(s)
        s = s.length if s.respond_to? :length
        self.range? ? self.size >= s : Col.is_valid?(self.to_i + s - 1)
      end

      def ==(o)
        self.to_idx == Col.to_idx(o)
      end

      def self.to_idx(v)
        begin
          case v
            when Fixnum then v - 1
            when String then self.to_idx(Integer(v))
            when Range  then self.to_idx(v.min)..self.to_idx(v.max)
            when Col    then v.to_idx
          end
        rescue ArgumentError
          nil
        end
      end

      def self.format(v)
        Col.new(v).to_i
      end

      def self.is_valid?(v)
        v = v.to_i if v.is_a? Col
        return self.is_valid?(v.min) && self.is_valid?(v.max) if v.is_a? Range
        idx = self.to_idx(v)
        idx ? (idx >= 0 and idx < COLS.size) : false
      end
    end
  end
end
