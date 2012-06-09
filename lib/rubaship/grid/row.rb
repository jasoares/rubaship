module Rubaship
  class Row

    ROWS = ("A".."J").to_a

    def initialize(v)
      idx = Row.to_idx(v)
      Row.is_valid?(idx) ? @idx = idx : raise(InvalidRowArgument.new v)
    end

    def size
      @idx.is_a?(Range) ? @idx.count : 1
    end

    alias :count :size
    alias :length :size

    def range?
      @idx.is_a?(Range)
    end

    def rangify!(size)
      return false if self.range?
      @idx = (@idx..@idx + size - 1)
      self.to_sym
    end

    def to_idx
      @idx
    end

    def to_sym
      str = self.to_s
      @idx.is_a?(Range) ? str.min.to_sym..str.max.to_sym : str.to_sym
    end

    def to_s
      v_to_s = Proc.new { |v| ('A'.ord + v).chr }
      @idx.is_a?(Range) ? v_to_s[@idx.min]..v_to_s[@idx.max] : v_to_s[@idx]
    end

    def ==(o)
      self.to_idx == Row.to_idx(o)
    end

    def self.to_idx(v)
      case v
        when String then ROWS.index(v)
        when Symbol then self.to_idx(v.to_s)
        when Range  then self.to_idx(v.min) .. self.to_idx(v.max)
        when Row    then v.to_idx
      end
    end

    def self.is_valid?(v)
      return self.is_valid?(v.min) && self.is_valid?(v.max) if v.is_a? Range
      idx = v.is_a?(Fixnum) ? v : self.to_idx(v)
      idx ? (idx >= 0 and idx < ROWS.size) : false
    end
  end
end
