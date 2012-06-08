module Rubaship
  class Row

    ROWS = ("A".."Z").to_a

    def initialize(v)
      @value = Row.to_idx(v)
    end

    def size
      @value.is_a?(Range) ? @value.count : 1
    end

    alias :count :size
    alias :length :size

    def range?
      @value.is_a?(Range)
    end

    def to_idx
      @value
    end

    def to_sym
      str = self.to_s
      @value.is_a?(Range) ? str.min.to_sym..str.max.to_sym : str.to_sym
    end

    def to_s
      v_to_s = Proc.new { |v| ('A'.ord + v).chr }
      @value.is_a?(Range) ? v_to_s[@value.min]..v_to_s[@value.max] : v_to_s[@value]
    end

    def ==(o)
      self.to_idx == Row.to_idx(o)
    end

    def self.to_idx(v)
      case v
        when Fixnum then v
        when String then ("A".."Z").to_a.index(v)
        when Symbol then self.to_idx(v.to_s)
        when Range  then self.to_idx(v.min) .. self.to_idx(v.max)
        when Row    then v.to_idx
      end
    end

    def self.rows(size=ROWS.size)
      ROWS.first(size)
    end
  end
end
