module Rubaship

  class Pos

    attr_reader :row, :col, :ori

    POS_REGEXP = /^
      (?:
        (?<row> [A-J] ) (?<col> [1-9]|10 ) | \g<col> \g<row>
      ) : (?<ori>
        h(o(r(i(z(o(n(t(a(l)?)?)?)?)?)?)?)?)? |
        v(e(r(t(i(c(a(l)?)?)?)?)?)?)?
      )
    $/ix

    def initialize(pos_row, col=nil, ori=nil)
      pos_row, col, ori = Pos.to_a(pos_row, col, ori)
      @row, @col, @ori = Row.new(pos_row), Col.new(col), Ori.new(ori)
    end

    def range?
      row.range? or col.range?
    end

    def rangify!(s)
      if self.ori.vert? && !self.row.range?
        self.row.rangify!(s)
      elsif self.ori.horiz? && !self.col.range?
        self.col.rangify!(s)
      end
      self
    end

    def to_a
      Pos.format(self.row, self.col, self.ori)
    end

    def to_s
      "#{self.row}#{self.col}:#{self.ori}"
    end

    def valid?(s)
      self.ori.vert? ? self.row.valid?(s) : self.col.valid?(s)
    end

    def ==(o)
      self.to_a == Pos.to_a(*o)
    end

    def self.is_valid?(pos_row, col=nil, ori=nil)
      begin
        row, col, ori = Pos.to_a(pos_row, col, ori)
        Row.is_valid? row and Col.is_valid? col and Ori.is_valid? ori
      rescue Exception
        false
      end
    end

    def self.format(row, col, ori)
      [Row.format(row), Col.format(col), Ori.format(ori)]
    end

    def self.parse(p)
      return nil unless m = POS_REGEXP.match(p)
      [m[:row].upcase.to_sym, m[:col].to_i, m[:ori][0].upcase.to_sym]
    end

    def self.to_a(pos_row, col=nil, ori=nil)
      return pos_row.to_a if pos_row.is_a?(Pos)
      if pos_row.is_a?(String) and !col and !ori
        pos_row, col, ori = Pos.parse(pos_row)
      else
        pos_row = Row.new(pos_row); col = Col.new(col)
        raise InvalidPositionArgument if
          !pos_row.range? && !col.range? && !ori or
           pos_row.range? && col.range? or
           pos_row.range? && ori == :H or
               col.range? && ori == :V
        ori = :V if pos_row.range?
        ori = :H if col.range?
      end
      self.format(pos_row, col, ori)
    end
  end
end
