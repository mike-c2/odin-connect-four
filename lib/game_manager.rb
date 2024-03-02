# frozen_string_literal: true

require_relative 'connect_four'

##
# This class drives the Connect 4 game
class GameManager
  attr_reader :num_rows, :num_columns

  DEFAULT_ROWS = 6
  DEFAULT_COLUMNS = 7

  def initialize(num_rows = DEFAULT_COLUMNS, num_columns = DEFAULT_COLUMNS)
    @num_rows = num_rows
    @num_columns = num_columns
    @connect_four = nil

    @players = [{ name: 'Player 1', marker: "\e[32mX\e[0m" },
                { name: 'Player 2', marker: "\e[31mO\e[0m" }]
  end

  def play_games
    loop do
      instructions
      play_game

      puts "\nWould you like to play again?\n\n"
      puts "Enter N to exit, anything else to play again.\n\n"

      break if gets.chomp.strip.upcase == 'N'

      @connect_four.reset
    end
  end

  def play_game
    setup unless @connect_four

    active_player = 0
    winner = false

    until winner || @connect_four.done?
      player_input(@players[active_player])
      winner = @connect_four.winner?(@players[active_player][:marker])
      active_player = (active_player + 1) % @players.length unless winner
    end

    puts @connect_four
    puts winner ? "#{@players[active_player][:name]} won the game!" : 'The game is a tie'
  end

  def setup
    grid = Grid.new(' ', num_rows, num_columns)
    @connect_four = ConnectFour.new(grid)
  end

  def instructions
    puts <<~INTRO

      Welcome to the Connect 4 Game!

      This is a 2 Player game, where each player takes a turn and
      drops their game marker into an available column.

      Each column is marked with a number 1 to #{num_columns}. To make a play,
      enter the number of the column that the game marker gets
      dropped into.

      First player to get 4 in a row, wins!

      If all columns fill up with no winner, then the game is a tie.
    INTRO
  end

  def player_input(player)
    puts "\n#{player[:name]}, it's your turn, choose a column to drop your marker.\n\n"
    puts "Enter the number above the column that you want to move.\n\n"
    puts @connect_four
    puts

    loop do
      player_input = gets.chomp.strip.to_i

      break if @connect_four.played?(player[:marker], player_input - 1)

      puts "\nWhat you entered is not valid, try again.\n\n"
    end
  end
end

game = GameManager.new
game.play_games
