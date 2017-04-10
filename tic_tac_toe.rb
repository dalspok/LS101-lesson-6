require "pry"

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

def prompt(message)
  puts "==> #{message}"
end

# rubocop: disable Metrics/AbcSize
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
# rubocop: enable Metrics/AbcSize

def initialize_board
  board = {}
  (1..9).each { |num| board[num] = INITIAL_MARKER }
  board
end

def empty_squares(brd)
  brd.keys.select { |key| brd[key] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  choice = ""
  loop do
    prompt "Please choose your square from (#{empty_squares(brd).join ', '}):"
    choice = gets.chomp.to_i
    break if empty_squares(brd).include?(choice)
    puts "Sorry, that's not a valid choice."
  end
  brd[choice] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  key = empty_squares(brd).sample
  brd[key] = COMPUTER_MARKER
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def check_line(brd, line, marker)
  brd[line[0]] == marker &&
    brd[line[1]] == marker &&
    brd[line[2]] == marker
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if check_line(brd, line, PLAYER_MARKER)
      return "Player"
    elsif check_line(brd, line, COMPUTER_MARKER)
      return "Computer"
    end
  end
  nil
end

loop do
  board = initialize_board

  loop do
    display_board(board)
    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end
  display_board(board)
  if someone_won?(board)
    puts "#{detect_winner(board)} won."
  else
    puts "It's a tie"
  end
  prompt "Do you want to play again? (y or n)"
  break if gets.chomp.downcase == "n"
end
prompt "Thanks for playing"
