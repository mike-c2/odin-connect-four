# frozen_string_literal: true

require_relative '../lib/node_array'

##
# This class is a grid of Nodes.
#
# It is built as an array of NodeArrays in row-major,
# but also has column-major and diagonal views.
# Each of these views will hold the same Node
# references.
#
# For example, a single node in a particular row, is
# also referenced by a column array and two diagonal
# arrays (uphill and downhill). If the node's value
# changes in one of those, then it changes in all.
#
# All arrays are frozen.
class Grid
  DEFAULT_ROWS = 6
  DEFAULT_COLUMNS = 7

  # See https://en.wikipedia.org/wiki/Row-_and_column-major_order
  # for meaning of major.
  #
  # Each of these are just different views of the
  # same grid. all_major is all of the other majors
  # combined into one array.
  #
  # row_major is the main view (grid is initially
  # built this way); column and diagonal majors are
  # derived from that.
  attr_reader :row_major, :column_major, :uphill_diagonal_major, :downhill_diagonal_major, :all_majors

  def initialize(initial_value = '', num_rows = DEFAULT_ROWS, num_columns = DEFAULT_COLUMNS)
    @row_major = self.class.build_row_major(initial_value, num_rows, num_columns)
    @column_major = self.class.derive_column_major(row_major)
    @uphill_diagonal_major = self.class.derive_uphill_diagonal_major(row_major)
    @downhill_diagonal_major = self.class.derive_downhill_diagonal_major(row_major)

    derive_all_majors
  end

  def clear(new_value = '')
    @row_major.each do |row|
      row.each { |node| node.value = new_value }
    end
  end

  def to_s
    pretty_grid = ''

    @row_major.each do |row|
      pretty_grid += row_separator

      row.each do |node|
        pretty_grid += "| #{node} "
      end

      pretty_grid += "|\n"
    end

    pretty_grid += row_separator
  end

  private

  def derive_all_majors
    @all_majors = row_major + column_major + uphill_diagonal_major + downhill_diagonal_major
  end

  def row_separator
    line_length = @row_major.first.length * 4 + 1
    "#{'-' * line_length}\n"
  end

  class << self
    def build_row_major(initial_value = '', rows = DEFAULT_ROWS, columns = DEFAULT_COLUMNS)
      row_major = Array.new(rows) { NodeArray.new(columns) { Node.new(initial_value) } }
      row_major.map!(&:freeze)

      row_major.freeze
    end

    def derive_column_major(node_arrays)
      column_major = node_arrays.transpose.map do |arr|
        node_array = NodeArray.new
        node_array.replace(arr)
        node_array.freeze
      end

      column_major.freeze
    end

    def derive_uphill_diagonal_major(node_arrays)
      uphill_diagonal_major = []

      # Go down the left side of the table (2-d array)
      (0...node_arrays.length).each do |row_index|
        uphill_array = single_uphill_diagonal(row_index, 0, node_arrays)
        uphill_diagonal_major.push(uphill_array.freeze)
      end

      # When we reach the last row, pivot and start going right
      (1...node_arrays.last.length).each do |column_index|
        uphill_array = single_uphill_diagonal(node_arrays.length - 1, column_index, node_arrays)
        uphill_diagonal_major.push(uphill_array.freeze)
      end

      uphill_diagonal_major.freeze
    end

    def derive_downhill_diagonal_major(node_arrays)
      downhill_diagonal_major = []

      # From top-right corner of the table (array), go left
      (0...node_arrays.first.length).to_a.reverse.each do |column_index|
        downhill_array = single_downhill_diagonal(0, column_index, node_arrays)
        downhill_diagonal_major.push(downhill_array.freeze)
      end

      # When we reach the top-left corner, go down.
      (1...node_arrays.length).each do |row_index|
        downhill_array = single_downhill_diagonal(row_index, 0, node_arrays)
        downhill_diagonal_major.push(downhill_array.freeze)
      end

      downhill_diagonal_major.freeze
    end

    private

    def single_uphill_diagonal(row_index, column_index, node_arrays)
      uphill_array = NodeArray.new

      while row_index >= 0 && column_index < node_arrays[row_index].length
        uphill_array.push(node_arrays[row_index][column_index])
        row_index -= 1
        column_index += 1
      end

      uphill_array
    end

    def single_downhill_diagonal(row_index, column_index, node_arrays)
      downhill_array = NodeArray.new

      while row_index < node_arrays.length && column_index < node_arrays[row_index].length
        downhill_array.push(node_arrays[row_index][column_index])
        row_index += 1
        column_index += 1
      end

      downhill_array
    end
  end
end
