require_relative "display"

class Player

  attr_reader :board, :color, :display

  def initialize(board, color)
    @display = Display.new(board, self)
    @board = board
    @color = color
  end

  def move
    start_pos = get_start_pos
    start_piece = board[*start_pos]
    end_pos = get_end_pos(start_piece)
    @display.reset_selected_pos
    board.move(start_pos, end_pos)
  rescue SamePieceSelectedError
    @display.reset_selected_pos
    retry
  end

  def select_pos
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end

  def get_start_pos
    start_pos = select_pos
    @display.highlighted_moves = board[*start_pos].valid_moves
    selected_piece = board[*start_pos]
    raise EmptyPieceSelected if !selected_piece.present?
    raise WrongColorSelected if selected_piece.color != color
    @display.set_selected_pos(start_pos)
    start_pos
  rescue EmptyPieceSelected
    retry
  rescue WrongColorSelected
    retry
  end

  def get_end_pos(start_piece)
    end_pos = select_pos
    @display.highlighted_moves = [] if @display.highlighted_moves.include?(end_pos)
    raise SamePieceSelectedError if end_pos == start_piece.pos
    raise InvalidMoveError if !start_piece.valid_moves.include?(end_pos)
    end_pos
  rescue InvalidMoveError
   retry
  end

end
