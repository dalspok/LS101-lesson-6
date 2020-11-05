EMPTY_MARK = " "
PLAYER_MARK = "X"
COMPUTER_MARK = "O"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                 [1, 4, 7], [2, 5, 8], [3, 6, 9],
                 [1, 5, 9], [3, 5, 7]]

def welcome
  system "clear"
  puts "Welcome to tic-tac-toe!"
  puts "-----------------------"
  puts "press ENTER to continue"
  gets
end

def initialize_board
  board = Hash.new
  (1..9).each { |key_num| board[key_num] = EMPTY_MARK }
  board
end

def display_board(brd)
  system "clear"
  puts
  puts "     |     |     "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |     "
  puts "-----|-----|-----"
  puts "     |     |     "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |     "
  puts "-----|-----|-----"
  puts "     |     |     "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |     "
  puts
end

def player_place_mark!(board)
  puts "Choose from #{empty_squares(board)}"
  player_choice = ""
  loop do
    player_choice = gets.chomp.to_i
    break if empty_squares(board).include? player_choice
    puts "Sorry, incorrect choice. Try again."
  end
  board[player_choice] = PLAYER_MARK
end

def computer_place_mark!(board)
  computer_choice = empty_squares(board).sample
  board[computer_choice] = COMPUTER_MARK
end

def empty_squares(board)
  board.select { |_, square| square == EMPTY_MARK }.keys
end

def winner(board)
  if full_winning_line(board, PLAYER_MARK)
    "Player"
  elsif full_winning_line(board, COMPUTER_MARK)
    "Computer"
  end
end

def full_winning_line(board, marker)
  WINNING_LINES.any? do |line|
    line.all? { |square| board[square] == marker }
  end
end

def someone_won?(board)
  !!winner(board)
end

def full?(board)
  empty_squares(board).empty?
end

def play_again?
  puts "Do you want to play again? (y - n)"
  choice = ""
  loop do
    choice = gets.chomp.downcase
    break if %w[y n].include? choice
    puts "Incorrect choice, try again."
  end
  choice == "y"
end

# ====== main game ========

welcome
loop do
  board = initialize_board

  # main loop
  loop do
    display_board(board)

    player_place_mark!(board)
    break if someone_won?(board) || full?(board)

    computer_place_mark!(board)
    break if someone_won?(board) || full?(board)
  end

  display_board(board)
  if someone_won?(board)
    puts "#{winner(board)} won!"
  else
    puts "It's a tie."
  end

  break unless play_again?
end

puts "Thank you for playing."
