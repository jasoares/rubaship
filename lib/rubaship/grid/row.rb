module Rubaship
  class Row

    ROWS = ("A".."J").to_a

    def initialize(v)
      raise InvalidRowArgument.new v unless Row.is_valid? v
      @idx = Row.to_idx v
    end

    def size
      self.range? ? @idx.count : 1
    end

    alias :count :size
    alias :length :size

    def range?
      @idx.is_a?(Range)
    end

    def rangify!(s)
      s = s.length if s.respond_to? :length
      return false if self.range?
      @idx = (@idx..@idx + s - 1)
      self.to_sym
    end

    def to_idx
      @idx
    end

    def to_sym
      str = self.to_s
      self.range? ? str.min.to_sym..str.max.to_sym : str.to_sym
    end

    def to_s
      v_to_s = Proc.new { |v| ('A'.ord + v).chr }
      self.range? ? v_to_s[@idx.min]..v_to_s[@idx.max] : v_to_s[@idx]
    end

    def valid?(s)
      s = s.length if s.respond_to? :length
      min = self.range? ? self.to_s.min : self.to_s
      Row.is_valid?((min.ord + s - 1).chr)
    end


    def ==(o)
      self.to_idx == Row.to_idx(o)
    end

    def self.to_idx(v)
      case v
        when String then ROWS.index(v.upcase)
        when Symbol then self.to_idx(v.to_s)
        when Range  then self.to_idx(v.min) .. self.to_idx(v.max)
        when Row    then v.to_idx
      end
    end

    def self.format(v)
      Row.new(v).to_sym
    end

    def self.is_valid?(v)
      return self.is_valid?(v.min) && self.is_valid?(v.max) if v.is_a? Range
      idx = self.to_idx(v)
      idx ? (idx >= 0 and idx < ROWS.size) : false
    end
  end
end
