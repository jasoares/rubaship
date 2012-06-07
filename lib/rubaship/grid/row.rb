module Rubaship
  class Row

    def initialize(v)
      @value = Row.to_idx(v)
    end

    def to_idx
      @value
    end

    def to_sym
      :"#{self.to_s}"
    end

    def to_s
      "#{('A'.ord + @value).chr}"
    end

    def ==(o)
      self.to_idx == Row.to_idx(o)
    end

    def self.to_idx(v)
      case v
        when Fixnum then v
        when String then Grid::ROWS.index(v)
        when Symbol then self.to_idx(v.to_s)
        when Row    then v.to_idx
      end
    end
  end
end
