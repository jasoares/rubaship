module Rubaship

  class Pos

    attr_reader :row, :col, :ori

    POSITION_REGEXP = /^(?<anchor>[A-J0-9]{2,3}):(?<orient>[a-z]{1,10})$/i
    ANCHOR_REGEXP = /^(?:(?<row>[A-J])(?<col>([1-9])|10)|\g<col>\g<row>)$/i
    ORIENT_REGEXP = /^(?<ori>
      h(o(r(i(z(o(n(t(a(l)?)?)?)?)?)?)?)?)? |
      v(e(r(t(i(c(a(l)?)?)?)?)?)?)?)$/ix

    def initialize(pos_row, col=nil, ori=nil)
      raise InvalidPositionError unless Pos.is_valid?(pos_row, col, ori)
      row, col, ori = Pos.to_a(pos_row, col, ori)
      @row, @col, @ori = Row.new(row), Col.new(col), Ori.new(ori)
    end

    def rangify!(s)
      s = s.size if s.is_a? Ship
      if self.ori.vert? && !self.row.range?
        self.row.rangify!(s)
      elsif self.ori.horiz? && !self.col.range?
        self.col.rangify!(s)
      end
    end

    def to_a
      [self.row.to_sym, self.col.to_i, self.ori.to_sym]
    end

    def ==(o)
      self.to_a == Pos.to_a(*o)
    end

    def self.is_valid?(pos_row, col=nil, ori=nil)
      if pos_row.is_a?(String) and !col and !ori
        pos_row, col, ori = self.parse pos_row
      end
      Row.is_valid?(pos_row) && Col.is_valid?(col) && Ori.is_valid?(ori)
    end

    def self.format(row, col, ori)
      [Row.format(row), Col.format(col), Ori.format(ori)]
    end

    def self.parse(p)
      return nil unless m = POSITION_REGEXP.match(p)
      anchor = ANCHOR_REGEXP.match(m[:anchor])
      orient = ORIENT_REGEXP.match(m[:orient])
      self.format(anchor[:row], anchor[:col], orient[:ori]) if anchor and orient
    end

    def self.to_a(pos_row, col=nil, ori=nil)
      if pos_row.is_a?(String) and !col and !ori
        pos_row, col, ori = self.parse pos_row
      elsif self.is_valid?(pos_row, col, ori)
        self.format(pos_row, col, ori)
      end
    end
  end
end
