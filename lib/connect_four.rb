# frozen_string_literal: true

require_relative '../lib/grid'

##
# This class is the Connect 4 game
class ConnectFour
  WINNING_LENGTH = 4
  BLANK = ' '

  def initialize(grid = Grid.new(BLANK))
    @grid = grid
  end

  def winner?(player_marker)
    @grid.all_majors.each do |line|
      return true if line.to_s.include?(player_marker * WINNING_LENGTH)
    end

    false
  end

  def done?
    @grid.column_major.each do |column|
      return false if column.to_s.include?(BLANK)
    end

    true
  end

  def played?(player_marker, column_index)
    column = @grid.column_major[column_index]

    return false unless column

    index = column.find_index(Node.new(BLANK))

    return false unless index

    column[index].value = player_marker

    true
  end

  def reset
    @grid.clear(BLANK)
  end

  def to_s
    @grid.column_major.each_with_index do |_, index|
      print "  #{index + 1} "
    end

    puts
    @grid.to_s
  end
end
