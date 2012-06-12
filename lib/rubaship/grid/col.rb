module Rubaship
  class Col

    COLS = ("1".."10").to_a

    def initialize(v)
      raise InvalidColArgument.new v unless Col.is_valid? v
      @idx = Col.to_idx v
    end

    def range?
      @idx.is_a?(Range)
    end

    def rangify!(s)
      s = s.size if s.respond_to? :length
      return false if self.range? or !Col.is_valid?(@idx + s)
      @idx = (@idx..@idx + s - 1)
      self.to_i
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

    def valid?(s)
      s = s.length if s.respond_to? :length
      min = self.range? ? self.to_i.min : self.to_i
      Col.is_valid?(min + s - 1)
    end

    def ==(o)
      self.to_idx == Col.to_idx(o)
    end

    def self.to_idx(v)
      case v
        when Fixnum then v - 1
        when String then self.to_idx(v.to_i)
        when Range  then self.to_idx(v.min)..to_idx(v.max)
        when Col    then v.to_idx
      end
    end

    def self.format(v)
      Col.new(v).to_i
    end

    def self.is_valid?(v)
      v = v.to_i if v.respond_to? :to_i
      return self.is_valid?(v.min) && self.is_valid?(v.max) if v.is_a? Range
      idx = self.to_idx(v)
      idx ? (idx >= 0 and idx < COLS.size) : false
    end
  end
end
