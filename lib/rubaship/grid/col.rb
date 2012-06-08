module Rubaship
  class Col

    COLS = ("1".."26").to_a

    def initialize(v, zero_based=false)
      @value = Col.to_idx(v, zero_based)
    end

    def range?
      @value.is_a?(Range)
    end

    def size
      self.range? ? @value.count : 1
    end

    def to_i
      self.range? ? (@value.min + 1)..(@value.max + 1) : @value + 1
    end

    def to_idx
      self.range? ? @value.min..@value.max : @value
    end

    def to_s
      int = self.to_i
      self.range? ? int.min.to_s..int.max.to_s : int.to_s
    end

    def ==(o)
      self.to_idx == Col.to_idx(o)
    end

    def self.to_idx(v, zero_based=false)
      case v
        when Fixnum then zero_based ? v : v - 1
        when String then to_idx(v.ord - '0'.ord, zero_based)
        when Range  then to_idx(v.min, zero_based)..to_idx(v.max, zero_based)
        when Col    then v.to_idx
      end
    end

    def self.cols(size=COLS.size)
      COLS.first(size)
    end
  end
end
