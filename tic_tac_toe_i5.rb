# 1. Display the initial empty 3x3 board.
# 2. Ask the user to mark a square.
# 3. Computer marks a square.
# 4. Display the updated board state.
# 5. If winner, display winner.
# 6. If board is full, display tie.
# 7. If neither winner nor board is full, go to #2
# 8. Play again?
# 9. If yes, go to #1
# 10. Good bye!

PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
EMPTY_MARKER = " "
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                 [1, 4, 7], [2, 5, 8], [3, 6, 9],
                 [1, 5, 9], [3, 5, 7]]

def initialize_board
  board = {}
  (1..9).each { |num| board[num] = EMPTY_MARKER }
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

def empty_squares(board)
  board.select {|_, marker| marker == EMPTY_MARKER}.keys
end

def player_place_piece!(board)
  puts "Choose your square (#{joinor(empty_squares(board))})"
  choice = ''
  loop do
    choice = gets.chomp.to_i
    break if empty_squares(board).include? choice
    puts "Sorry, it's not a valid choice. Try again."
    puts
  end
  board[choice] = PLAYER_MARKER
end

def computer_place_piece!(board)
  choice = empty_squares(board).sample
  board[choice] = COMPUTER_MARKER
end

def joinor(arr, char_between = ", ", ending_char = "or")
  return arr.first.to_s if arr.size < 2
  starting_seq = arr[0..-2].join(char_between)
  "#{starting_seq}#{char_between}#{ending_char} #{arr.last}"
end

def board_full?(board)
  empty_squares(board).empty?
end

def someone_won?(board)
  !!detect_winner(board)
end

def detect_winner(board)
  if WINNING_LINES.any? do |squares|
    board.values_at(*squares).count(PLAYER_MARKER) == 3
   end
   "Player"
  elsif WINNING_LINES.any? do |squares|
    board.values_at(*squares).count(COMPUTER_MARKER) == 3
   end
   "Computer"
  else
    nil
  end
end

def display_results(board)
  if someone_won?(board)
    puts "#{detect_winner(board)} won!"
    puts
  else
    puts "It's a tie"
    puts
  end
end

def play_again?
  puts "Do you want to play again (y/n)?"
  choice = ''
  loop do
    choice = gets.chomp.downcase
    break if %w(y n).include? choice
    puts "Incorrect choice. Please try again."
    puts
  end
  choice == "y"
end

loop do
  board = initialize_board

  loop do
    display_board(board)
    player_place_piece!(board)
    break if board_full?(board) || someone_won?(board)

    computer_place_piece!(board)
    break if board_full?(board) || someone_won?(board)
  end

  display_board(board)
  display_results(board)
  break unless play_again?
end

puts "Thank you for playing."



