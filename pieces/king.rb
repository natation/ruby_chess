require_relative "piece"
require_relative "steppable"

class King < Piece
  include Steppable

  def possible_moves
    generate_possible_moves(1, 1) + generate_possible_moves(1, 0)
  end

  def to_s
    color == :white ? "♔ " : "♚ "
  end
end
