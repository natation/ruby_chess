require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  attr_reader :board
  attr_accessor :highlighted_moves

  def initialize(board, player)
    @board = board
    @player = player
    @cursor_pos = [0, 0]
    @selected_pos = nil
    @highlighted_moves = []
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :yellow
    elsif [i, j] == @selected_pos
      bg = :light_green
    elsif !@selected_pos.nil? && @highlighted_moves.include?([i, j])
      bg = :light_green
    elsif (i + j).odd?
      bg = :magenta
    else
      bg = :light_white
    end
    { background: bg, color: :black }
  end

  def render
    system("clear")
    puts "  " * 50
    puts "#{@player.color.capitalize}'s turn!"
    if board.checkmate?(@player.color)
      puts "Checkmate!"
    else
      puts "You are in check!" if board.in_check?(@player.color)
      puts "Please select a position to move from and to (use arrows and spacebar)"
    end
    puts "  " * 50
    build_grid.each { |row| puts row.join }
    puts "  " * 50
  end

  def reset_selected_pos
    @selected_pos = nil
  end

  def set_selected_pos(pos)
    @selected_pos = pos.dup
  end
end
