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

      def initialize(*args)
        args = Pos.parse(*args) if args.size == 1 and args[0].is_a? String
        @row, @col = Row.new(args[0]), Col.new(args[1])
        args[2] ||= @row.range? ? :V : @col.range? ? :H : nil
        raise InvalidPositionArgument unless Pos.is_valid?(*args)
        @ori = Ori.new(args[2])
      end

      def eql?(o)
        o.is_a? Pos and row.eql? o.row and col.eql? o.col and ori.eql? o.ori
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
          when String then Pos.parse(o)
          when Array  then o
          when Pos    then o.to_a
        end
        self.row == row and self.col == col and self.ori == ori
      end

      def self.is_valid?(row, col, ori=nil)
        return false unless Row.is_valid?(row) and Col.is_valid?(col)
        row, col = Row.new(row), Col.new(col)
        return false if row.range? && col.range? or ori && !Ori.is_valid?(ori) or
          !row.range? && !col.range? && !ori
        if ori
          ori = Ori.new(ori)
          return false if row.range? && ori.horiz? or col.range? && ori.vert?
        end
        true
      end

      def self.format(row, col, ori)
        [Row.format(row), Col.format(col), Ori.format(ori)]
      end

      def self.parse(p)
        return nil unless m = POS_REGEXP.match(p)
        self.format(m[:row], m[:col], m[:ori])
      end
    end
  end
end
