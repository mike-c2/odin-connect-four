# Hangman Game

## Introduction

This is a text-based Connect 4 game that was made as part of [The Odin Project](https://www.theodinproject.com), which is written in Ruby.

The project details can be found at [Project: Connect Four](https://www.theodinproject.com/lessons/ruby-connect-four).

For more details about the game, see [Connect Four](https://en.wikipedia.org/wiki/Connect_Four)

## How to Play

Start the game by running:

```
ruby lib/game_manager.rb
```

This will display the following instructions:

```
Welcome to the Connect 4 Game!

This is a 2 Player game, where each player takes a turn and
drops their game marker into an available column.

Each column is marked with a number 1 to 7. To make a play,
enter the number of the column that the game marker gets
dropped into.

First player to get 4 in a row, wins!

If all columns fill up with no winner, then the game is a tie.

Player 1, it's your turn, choose a column to drop your marker.

Enter the number above the column that you want to move.

  1   2   3   4   5   6   7
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------

```

Entering 4 and hitting enter results in this move:

```
Player 2, it's your turn, choose a column to drop your marker.

Enter the number above the column that you want to move.

  1   2   3   4   5   6   7
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   | X |   |   |   |
-----------------------------
```

Then Player 2 will enter a column, for example 3, which will result in:

```
Player 1, it's your turn, choose a column to drop your marker.

Enter the number above the column that you want to move.

  1   2   3   4   5   6   7
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   |   |   |   |   |   |
-----------------------------
|   |   | O | X |   |   |   |
-----------------------------

```

The play continues alternating between Player 1 and Player 2, until someone gets 4 in a row and wins the game. If the board fills up with no winner, then it ends in a tie.

At the end of the game, the use is given an option to start a new game or exit the program.
