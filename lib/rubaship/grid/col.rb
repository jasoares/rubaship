module Rubaship
  class Col

    COLS = ("1".."10").to_a

    def initialize(v)
      @idx = Col.to_idx(v)
    end

    def range?
      @idx.is_a?(Range)
    end

    def size
      self.range? ? @idx.count : 1
    end

    def to_i
      self.range? ? (@idx.min + 1)..(@idx.max + 1) : @idx + 1
    end

    def to_idx
      self.range? ? @idx.min..@idx.max : @idx
    end

    def to_s
      int = self.to_i
      self.range? ? int.min.to_s..int.max.to_s : int.to_s
    end

    def ==(o)
      self.to_idx == Col.to_idx(o)
    end

    def self.to_idx(v)
      case v
        when Fixnum then v - 1
        when String then to_idx(Integer(v))
        when Range  then to_idx(v.min)..to_idx(v.max)
        when Col    then v.to_idx
      end
    end
  end
end
