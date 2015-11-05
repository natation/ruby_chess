# Chess

This is a two-player chess game written in Ruby and playable in the terminal.

## How to Play

Make sure you have Ruby installed on your machine. Clone this repository and cd
into the folder from the terminal. Type "ruby ./game.rb" to run the game. If the
pieces seem too small, zoom in to display a larger board.

## About

* Highlights possible moves for selected piece
* Pieces inherit from the piece class to reuse methods needed for all pieces
* Slideable (for queen, bishop, rook) and Steppable (for king, knight) modules
* Displays info about current game status (who's turn, in_check?, checkmate?)
* Utilizes Colorize gem for custom colors

## Code Discussion

The chess board is a 2-D, 8 x 8, grid. I set up bracket methods for
easy setting and getting on the grid. The board is initialized as a standard
board setup. On empty squares, I use the null object pattern so I don't have to
check for null. Thus, I invoke the same methods on any square regardless of
whether it contains a piece or is empty.

Move validation is the most difficult part of implementing chess. The reason is
because there are 6 different pieces per color and they all move differently.
I wanted to be able to extract the common move functionality and DRY out and
make the code clean.
First, I modularized Steppable and Slideable:
```ruby
module Slideable
  def generate_possible_moves(delta_1, delta_2)
    possible_moves = []
    generate_all_deltas(delta_1, delta_2).each do |deltas|
      possible_moves += extend_in_direction(deltas)
    end
    possible_moves
  end

  def extend_in_direction(deltas)
    extended_moves = []
    unable_to_proceed = false
    shifted_pos = pos.dup
    until unable_to_proceed
      shifted_pos = pos_with_deltas(shifted_pos, deltas)
      break if !board.in_bounds?(shifted_pos)
      other_piece = board[*shifted_pos]
      if other_piece.color != color
        extended_moves << shifted_pos
      end
      unable_to_proceed = true if other_piece.present?
    end
    extended_moves
  end
end
```
```ruby
module Steppable
  def generate_possible_moves(delta_1, delta_2)
    possible_moves = []
    generate_all_deltas(delta_1, delta_2).each do |deltas|
      shifted_pos = pos_with_deltas(pos, deltas)
      possible_moves << shifted_pos
    end
    possible_moves.select do |possible_move|
      piece = board[*possible_move] if board.in_bounds?(possible_move)
      piece && piece.color != color
    end
  end
end
```
This allows possible move calculations for Slideable pieces (queen, rook, bishop)
and Steppable pieces (king, knight), given each of their "move deltas", which are
seeded inside its respective piece class.
Next, I extracted common piece functionality into a parent Piece class, which
includes calculating all its "move deltas" and its possible moves. In addition,
we do not want the move to put the moving player into check, so we check
this as well, no pun intended, in the Piece class.

Seeing whether a player is in check is the crux of implementing chess. There are
two approaches to this:
1. Duplicating the board and making the move on the duplicated board.
2. Actually making the move on the board, but not rendering until the move is
   determined to be valid.
I chose the latter approach as I feel this is more intuitive, closer to what
happens in real-life, and would save the memory of duplicating the board.
Not duplicating the board presents its own challenges, however, as you have to
actually move each piece on the board to all its possible moves (taking care of
resurrecting a piece if it has been killed off by a possible move).

## Improvements

There are some improvements I would still like to add: [Castling][castling],
[Pawn Promotion][promotion], and [en passant][enpassant]. All in all, I really
enjoyed making this chess game and it helped me understand inheritance, keeping
code DRY and reusable, and how to systematically tackle larger problems.

[castling]: https://en.wikipedia.org/wiki/Castling
[promotion]: https://en.wikipedia.org/wiki/Promotion_(chess)
[enpassant]: https://en.wikipedia.org/wiki/En_passant
