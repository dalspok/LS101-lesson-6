
board = {}
PLAYER_MARK = "X"
COMPUTER_MARK = "O"
EMPTY_MARK = " "
WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9],
                 [1,4,7], [2,5,8], [3,6,9],
                 [1,5,9], [3,5,7]]

def reset_board(board)
   (1..9).each { |num| board[num] = EMPTY_MARK}
end


def display_board(board)
  system "clear"
  puts
  puts "     |     |     "
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
  puts "     |     |     "
  puts "-----|-----|-----"
  puts "     |     |     "
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
  puts "     |     |     "
  puts "-----|-----|-----"
  puts "     |     |     "
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
  puts "     |     |     "
  puts
end

def welcome_message
  puts "----------------------------"
  puts "Welcome to Tic-tac-toe game!"
  puts "----------------------------"
  puts
  puts "Press ENTER to start"
  gets
end

def empty_squares(board)
  empty = board.select { |_, mark| mark == EMPTY_MARK}
  empty.keys
end

def joinor(squares, split_mark = ", ", last_mark = ", or ")
  formatted_string = ""
  squares.each_with_index do |number, index|
    formatted_string << number.to_s
    split_by =  case index
                when squares.size - 1
                  ""
                when squares.size - 2
                  last_mark
                else
                  split_mark
                end
    formatted_string << split_by
  end
  formatted_string
end

def player_moves(board)
  puts "What is your choice? (#{joinor(empty_squares(board))})"
  choice = gets.chomp.to_i
  board[choice] = PLAYER_MARK
end

def computer_moves(board)
  choice = empty_squares(board).sample
  board[choice] = COMPUTER_MARK
end

def determine_winner(board)
  if winner?(PLAYER_MARK, board)
    "Player"
  elsif winner?(COMPUTER_MARK, board)
    "Computer"
  else
    nil
  end
end

def someone_won?(board)
  !!determine_winner(board)
end

def winner?(mark, board)
  WINNING_LINES.any? do |line|
  line.all? do |square_num|
    board[square_num] == mark
    end
  end
end

def board_full?(board)
  empty_squares(board).empty?
end

#welcome_message
reset_board(board)

loop do
  display_board(board)
  player_moves(board)
  break if someone_won?(board) || board_full?(board)
  computer_moves(board)
  break if someone_won?(board) || board_full?(board)
end

display_board(board)
if someone_won?(board)
  puts "Winner is #{determine_winner(board)}"
else
  puts "It's a tie"
end

