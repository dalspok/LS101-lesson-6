INITIAL_MARKER = " "
WHO_STARTS_GAME = "choose" # "player", "computer" or "choose"
FINAL_SCORE = 5
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]
score = { player: 0, computer: 0 }

# METHOD DEFINITIONS

def prompt(message)
  puts "==> #{message}"
end

# rubocop: disable Metrics/AbcSize
def display_board(board, score)
  system "clear"
  puts "YOU:COMPUTER #{score[:player]}:#{score[:computer]}"
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
# rubocop: enable Metrics/AbcSize

def initialize_board
  board = {}
  (1..9).each { |num| board[num] = INITIAL_MARKER }
  board
end

def empty_squares(board)
  board.keys.select { |key| board[key] == INITIAL_MARKER }
end

def joinor(arr, default_joiner = ", ", end_joiner = "or")
  last = arr[-1]
  return last.to_s if arr.empty? || arr.size == 1
  arr[0...-1].join(default_joiner) + default_joiner + end_joiner \
  + ' ' + last.to_s
end

def player_places_piece!(board)
  choice = ""
  loop do
    prompt "Please choose your square from (#{joinor(empty_squares(board))}):"
    choice = gets.chomp.to_i
    break if empty_squares(board).include?(choice)
    prompt "Sorry, that's not a valid choice."
  end
  board[choice] = PLAYER_MARKER
end

def third_square_in_row(board, marker)
  WINNING_LINES.each do |line|
    str = board[line[0]] + board[line[1]] + board[line[2]]
    if str.count(marker) == 2
      line.each do |index|
        return index if board[index] == INITIAL_MARKER
      end
    end
  end
  false
end

def check_middle_square(board)
  empty_squares(board).include?(5) ? 5 : false
end

def computer_places_piece!(board)
  key = third_square_in_row(board, COMPUTER_MARKER) ||
        third_square_in_row(board, PLAYER_MARKER) ||
        check_middle_square(board) ||
        empty_squares(board).sample
  board[key] = COMPUTER_MARKER
end

def alternate(player)
  if player == "computer"
    "player"
  elsif player == "player"
    "computer"
  end
end

def next_places_piece!(board)
  if board[:who_goes] == "player"
    player_places_piece!(board)
  elsif board[:who_goes] == "computer"
    computer_places_piece!(board)
  end
  board[:who_goes] = alternate(board[:who_goes])
end

def someone_won?(board)
  !!detect_winner(board)
end

def board_full?(board)
  empty_squares(board).empty?
end

def check_line(board, line, marker)
  board[line[0]] == marker &&
    board[line[1]] == marker &&
    board[line[2]] == marker
end

def detect_winner(board)
  WINNING_LINES.each do |line|
    if check_line(board, line, PLAYER_MARKER)
      return :player
    elsif check_line(board, line, COMPUTER_MARKER)
      return :computer
    end
  end
  nil
end

def update_score(score, winner)
  score[winner] += 1
end

def detect_absolute_winner(score)
  return "Player" if score[:player] == FINAL_SCORE
  return "Computer" if score[:computer] == FINAL_SCORE
  nil
end

def check_starting(who_starts_game)
  system "clear"
  prompt "Welcome to Tic-Tac-Toe. Who wins #{FINAL_SCORE} games, " \
  "takes the price."
  unless who_starts_game == "choose"
    prompt "Press Enter to start."
    gets
    return who_starts_game
  end
  ask_who_starts
end

def ask_who_starts
  choice = nil
  loop do
    prompt "Who do you want to start? (C-omputer, P-layer)"
    choice = gets.chomp.chr.downcase
    break if choice == "c" || choice == "p"
    prompt "Not a valid choice, try again"
  end
  choice == "c" ? "computer" : "player"
end

def display_result(board, score)
  display_board(board, score)
  if someone_won?(board)
    winner = detect_winner(board)
    prompt "#{winner.to_s.upcase} won."
    update_score(score, winner)
  else
    prompt "It's a tie"
  end
end

# START OF GAME

who_starts_round = check_starting(WHO_STARTS_GAME)

# MAIN LOOP
loop do             # one game
  board = initialize_board
  board[:who_goes] = who_starts_round

  loop do           # one move
    display_board(board, score)
    next_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end
  display_result(board, score)
  who_starts_round = alternate(who_starts_round)
  prompt "Press Enter to continue"
  gets
  if detect_absolute_winner(score)
    display_board(board, score)
    break
  end
end

prompt "Absolute winner is: #{detect_absolute_winner(score)}"
prompt "Thanks for playing"
