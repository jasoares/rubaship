module Rubaship
  module Grid
    class Grid
      include Enumerable

      POSITION_REGEXP = /^(?<anchor>[A-Z0-9]{2,3}):(?<orientation>[a-z]{1,10})$/i
      ANCHOR_REGEXP = /^(?:(?<row>[A-J])(?<col>([1-9])|10)|\g<col>\g<row>)$/i
      ORIENT_REGEXP = /^(?<ori>
        h(o(r(i(z(o(n(t(a(l)?)?)?)?)?)?)?)?)? |
        v(e(r(t(i(c(a(l)?)?)?)?)?)?)?)$/ix

      def initialize
        @grid = Array.new(10) { Array.new(10) { Sector.new } }
      end

      def initialize_copy(orig)
        s = orig.enum_for(:each_sector)
        @grid = Array.new(10) { Array.new(10) { s.next.dup } }
      end

      def ==(o)
        return case o
          when Hash  then to_hash == o
          when Array then self.to_a == o
          when Grid then self.to_a == o.to_a
        end
      end

      def [](idx1, idx2=nil)
        if idx2.nil?
          row = Row.is_valid?(idx1) ? Row.new(idx1) : Row.new(:A..:J)
          col = Col.is_valid?(idx1) ? Col.new(idx1) : Col.new(1..10)
        else
          row = Row.new(idx1); col = Col.new(idx2)
        end
        subgrid = @grid[row.to_idx]
        if row.range?
          subgrid = subgrid.transpose[col.to_idx]
          return col.range? ? subgrid.transpose : subgrid
        end
        subgrid[col.to_idx]
      end

      def add(ship, *pos)
        self.dup.add!(ship, *pos)
      end

      def add!(ship, *pos)
        p = pos.is_a?(Pos) ? pos : Pos.new(*pos)
        raise InvalidPositionForShip.new(ship, p) unless p.valid?(ship)
        p.rangify!(ship)

        insert_ship = lambda { |sector| sector.ship = ship }
        grid = self[p.row, p.col]
        if v = grid.inject(nil) { |r, sector| r ||= sector.ship }
          raise OverlapShipError.new(v)
        end
        grid.each(&insert_ship)
        p
      end

      def col(col)
        @grid.transpose[Col.new(col).to_idx]
      end

      def row(row)
        @grid[Row.new(row).to_idx]
      end

      def each
        if block_given?
          @grid.collect do |row|
            row.collect { |sector| yield sector }
          end
        else
          self.to_enum
        end
      end

      alias :each_sector :each

      alias :sectors :each

      def each_col
        if block_given?
          @grid.transpose.each { |col| yield col }
        else
          self.enum_for(:each_col)
        end
      end

      alias :cols :each_col

      def each_row
        if block_given?
          @grid.each { |row| yield row }
        else
          self.enum_for(:each_row)
        end
      end

      alias :rows :each_row

      def sector(row, col)
        self[row, col]
      end

      def to_hash
        @grid.each_with_index.inject({}) do |row_hash, (row, i)|
          row_hash[Row::ROWS[i].to_sym] = row.collect { |sector| sector.to_hash }
          row_hash
        end
      end

      def to_a
        @grid
      end

      def to_s(empty=" ", sep="|", col_width=3)
        to_cell = Proc.new do |v|
          sep + (v.is_a?(Sector) ? v.to_s(empty) : v.to_s).center(col_width)
        end
        to_row = Proc.new do |row|
          to_cell.(row[0]) + row[1].map(&to_cell).join + "#{sep}\n"
        end

        str = to_row.([empty] << (1..10).to_a)
        Row::ROWS.zip(self.rows).inject(str) do |s, row|
          s << to_row.(row)
        end
      end
    end
  end
end
