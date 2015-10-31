
class Board
  MOVES = [[-1,-1], [-1, 0], [-1, 1], [0, 1],[0, -1], [1, -1], [1, 0], [1, 1]]
  attr_reader :bomb_coords

  def initialize(size, num_bombs)
    @user_board = Array.new(size) {Array.new(size)}
    @hidden_board = Array.new(size) {Array.new(size)}
    @size = size
    @bomb_coords = []
    set_bombs(num_bombs)
  end

  def set_bombs(num_bombs)
    num_bombs.times do |_|
      row = rand(@size)
      col = rand(@size)
      @bomb_coords << [row,col]

      @hidden_board[row][col] = :b
    end
  end

  def update(pos, pos_content)
    x,y = pos
    @user_board[x][y] = pos_content
  end

  def reveal_square(pos)
    if valid_reveal?(pos)
      x, y = pos
      square_contents = @hidden_board[x,y]
      if square_contents == :b
        return :b
      else
        num_adj_bombs = check_adjacent_squares(pos)
        if num_adj_bombs > 0
          return num_adj_bombs
        else
          return "_"
        end
      end

    else
      # raise "Square is occupied"
      # # rescue
      #   return nil
      # end
    end
  end

  def check_adjacent_squares(pos)
    x,y = pos
    bomb_counter = 0
    MOVES.each do |(dx,dy)|
      new_pos = [x + dx, y + dy]

      if new_pos.all?{|coord| coord.between?(0,@size-1)}
        if @hidden_board[x + dx][y + dy] == ":b"
         bomb_counter += 1
        end
      end
    end
    bomb_counter
  end

  def display
    puts "  #{(0...@size).to_a.join(" ")}"
    @user_board.each_with_index do |row, i|
        puts "#{i} #{row.join(" ")}"
    end
  end

  def all_revealed?
    row = 0
    while row < @size
      col = 0
      while col < @size
        if @bomb_coords.include?([row,col])
          break
        else
          unless (@user_board[row][col] == "_") || (@user_board[row][col].is_a?(Integer))
            return false
          end
        end
        col += 1
      end
      row += 1
    end
    return true
  end

  def valid_reveal?(pos)
    x, y = pos
    if x > @size || x < 0 || y > @size || y < 0
      return false
    elsif @user_board[x][y] == "F" || @user_board[x][y].is_a?(Integer) || @user_board[x][y] == "_"
      return false
    else
      return true
    end
  end
end
