module Rubaship
  module Grid
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
        [row.to_pos, col.to_pos, ori.to_pos]
      end

      def to_ary
        [row, col, ori]
      end

      def to_hash
        { :row => row, :col => col, :ori => ori }
      end

      def to_s
        "#{self.row}#{self.col}:#{self.ori}"
      end

      def valid?(s)
        self.ori.vert? ? self.row.valid?(s) : self.col.valid?(s)
      end

      def ==(o)
        row, col, ori = case o
          when String then Pos.parse(o).to_a
          when Array  then o
          when Pos    then o.to_a
        end
        self.row == row and self.col == col and self.ori == ori
      end

      def self.is_valid?(row, col, ori=nil)
        ori ||= row.is_a?(Range) ? :V : (col.is_a?(Range) ? :H : nil)
        if row.is_a?(Range) && ori == :H or col.is_a?(Range) && ori == :V
          return false
        end
        Row.is_valid? row and Col.is_valid? col and Ori.is_valid? ori
      end

      def self.format(row, col, ori)
        [Row.format(row), Col.format(col), Ori.format(ori)]
      end

      def self.parse(p)
        return nil unless m = POS_REGEXP.match(p)
        self.to_a(m[:row], m[:col], m[:ori])
      end

      def self.to_a(pos_row, col=nil, ori=nil)
        if !col and !ori
          return pos_row.to_a if pos_row.is_a? Pos
          return self.parse(pos_row) if pos_row.is_a? String
        else
          pos_row, col = Row.new(pos_row), Col.new(col)
          raise InvalidPositionArgument if
            !pos_row.range? && !col.range? && !ori or
             pos_row.range? && col.range? or
             pos_row.range? && ori == :H or
                 col.range? && ori == :V
          ori = :V if pos_row.range?
          ori = :H if col.range?
        end
        self.format pos_row, col, ori
      end
    end
  end
end
