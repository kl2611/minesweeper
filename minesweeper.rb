require_relative "board"
require 'byebug'

class Minesweeper
  MOVES = [[-1,-1], [-1, 0], [-1, 1], [0, 1],[0, -1], [1, -1], [1, 0], [1, 1]]

  attr_accessor :game_board, :size

  def initialize(size = 9, num_bombs = 10)
    @size = size
    @game_board = Board.new(size, num_bombs)
    @hit_a_bomb = false
    @checked_pos = []
  end

  # def [](pos)
  #   x,y = pos
  #   game_board[x][y]
  # end
  #
  # def []= (pos, value)
  #   x,y = pos
  #   game_board[x][y] = value
  # end

  def play
    until over?
    update
    user_input = prompt_player
    pos = user_input[:pos]
      if user_input[:action] == 'r'
        reveal(pos)
      else
        flag_bomb(pos)
      end
        update
    end
    "Game over!"
  end

  def prompt_player
    puts "Choose to reveal or flag: r or f"
    action = gets.chomp
    puts "Choose a position: row col"
    pos = gets.chomp.split(' ').map(&:to_i)# {|num| num.to_i}
    {:action => action, :pos => pos}
  end

  def update
    @game_board.display
  end

  def reveal(pos)
    x, y = pos
    pos_content = @game_board.reveal_square(pos)
    if pos_content == :b
      @hit_a_bomb = true
    elsif pos_content.is_a?(Integer)
      game_board.update(pos, pos_content)
    elsif pos_content == "_"
      rev_adj_empty_square(pos)
    end
  end

  def rev_adj_empty_square(pos)
    @checked_pos << pos
    valid_moves = get_valid_moves(pos)

    until valid_moves.empty?
      square = valid_moves.shift
      square_content = @game_board.reveal_square(square)

      if square_content == :b
         next
      elsif square_content.is_a?(Integer)
        game_board.update(square,square_content)
        @checked_pos << square
      elsif square_content == "_"
        rev_adj_empty_square(square) unless @checked_pos.include?(square)
      end

    end
  end

  def get_valid_moves(pos)
    x,y = pos
    valid_moves = []

    MOVES.each do |(dx,dy)|
      new_pos = [x + dx, y + dy]

       if new_pos.all?{|coord| coord.between?(0,size-1)}
         valid_moves << new_pos
       end
    end
    valid_moves
  end


  def flag_bomb(pos)
    x,y = pos
    @game_board.update(pos, 'F')
  end

  def over?
    if @hit_a_bomb
      return true
    else
      return @game_board.all_revealed?
    end
  end
end

a = Minesweeper.new
a.play
