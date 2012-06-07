module Rubaship
  class Col

    def initialize(v, zero_based=false)
      @value = Col.to_idx(v, zero_based)
    end

    def to_i
      @value + 1
    end

    def to_idx
      @value
    end

    def to_s
      self.to_i.to_s
    end

    def ==(o)
      self.to_idx == Col.to_idx(o)
    end

    def self.to_idx(v, zero_based=false)
      case v
        when Fixnum then zero_based ? v : v - 1
        when String then self.to_idx(v.ord - '0'.ord)
        when Col    then v.to_idx
      end
    end

    def self.cols(size=10)
      ("1"..size.to_s).to_a
    end
  end
end
