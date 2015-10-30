class Minesweeper
  attr_accessor :board, :size

  def initalize(size = 9, num_bombs = 10)
    @size = size
    @board = Array.new(size) {Array.new(size)}
    set_bombs(num_bombs)
  end

  def set_bombs(num_bombs)
    num_bombs.times do |_|
      self[rand(size), rand(size)] = :b
    end
  end

  def [](pos)
    x,y = pos
    @board[x][y]
  end

  def []= (pos, value)
    x,y = pos
    @board[x][y] = value
  end

  def play
    prompt_player

  end

  def prompt_player
    puts "Choose to reveal or flag: r or f"
    action = gets.chomp
    puts "Choose a position: row col"
    pos = gets.chomp.split(' ')
  end

  def update
  end

  def reveal

  end

end
