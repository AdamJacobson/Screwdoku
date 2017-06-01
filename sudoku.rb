require_relative "board"
require 'colorize'
require 'byebug'

class SudokuGame
  def self.from_file(filename)
    # debugger
    self.new(Board.from_file(filename))
  end

  def initialize(board)
    # debugger
    @board = board
  end

  def method_missing(method_name, *args)
    # debugger
    if method_name =~ /val/
      Integer(args[0])
    else
      string = args[0]
      string.split(",").map! { |char| Integer(char) }
    end
  end

  def get_pos
    pos = nil
    until pos && valid_pos?(pos)
      puts "Please enter a position on the board (e.g., '3,4')"
      print "> "

      begin
        pos = parse_pos(gets.chomp)
      rescue
        puts "Invalid position entered (did you use a comma?)"
        puts ""

        pos = nil
      end
    end
    pos
  end

  def get_val
    val = nil
    until val && valid_val?(val)
      puts "Please enter a value between 1 and 9 (0 to clear the tile)"
      print "> "
      val = parse_val(gets)
    end
    val
  end

  def play_turn
    board.render
    pos = get_pos
    val = get_val
    board[pos] = val
  end

  def run
    play_turn until solved?
    board.render
    puts "Congratulations, you win!"
  end

  def solved?
    p board.solved?
  end

  def valid_pos?(pos)
    if pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |x| (0..board.size - 1).cover?(x) }
      true
    else
      get_pos
    end
  end

  def valid_val?(val)
    val.is_a?(Integer) && val.between?(0, 9)
  end

  private

  attr_reader :board
end

  game = SudokuGame.from_file("puzzles/sudoku1-almost.txt")
  game.run
