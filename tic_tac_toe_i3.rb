require "pry"

WINNING_MOVES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [3, 5, 7],
                 [1, 4, 7], [2, 5, 8], [3, 6, 9]]
PLAYER_MARK = "X"
COMPUTER_MARK = "O"
EMPTY_MARK = " "

def start_game
  system "clear"
  puts "Welcome to Tic-Tac-Toe"
  puts "Press any key to start"
  gets
  system "clear"
end

def initialize_board
  board = {}
  (1..9).each { |key| board[key] = EMPTY_MARK }
  board
end

def display_board(board)
  system "clear"
  puts "+---+---+---+"
  puts "| #{board[1]} | #{board[2]} | #{board[3]} |"
  puts "+---+---+---+"
  puts "| #{board[4]} | #{board[5]} | #{board[6]} |"
  puts "+---+---+---+"
  puts "| #{board[7]} | #{board[8]} | #{board[9]} |"
  puts "+---+---+---+"
  puts
end

def player_choice(board)
  loop do
    puts "What is your move? (#{available_moves_as_text(board)})"
    player = gets.chomp.to_i
    if valid_move?(board, player)
      return player
    end
    puts "It is not a valid move."
  end
end

def valid_move?(board, move)
  available_moves(board).include? move
end

def available_moves_as_text(board)
  moves = available_moves(board)
  last_joiner = " or "
  case moves.size
  when 1 then moves[0].to_s
  when 2 then moves.join(last_joiner)
  else
    moves[0..-2].join(", ") + last_joiner + moves[-1].to_s
  end
end

def available_moves(board)
  board.select { |_, field| field == EMPTY_MARK }
       .keys
end

def determine_winner(board)
  if full_triplet?(board, PLAYER_MARK)
    :player
  elsif full_triplet?(board, COMPUTER_MARK)
    :computer
  end
end

def winner?(board)
  !!determine_winner(board)
end

def full_triplet?(board, mark)
  WINNING_MOVES.any? do |triplet|
    triplet.all? { |square| board[square] == mark }
  end
end

def tie?(board)
  !winner?(board) && !board.values.include?(EMPTY_MARK)
end

def play_again?
  loop do
    puts "Do you want to play again? (y/n)"
    again = gets.chomp.downcase
    return again if %w[y n].include?(again)
    puts "Invalid input. Please try again."
  end
end

def display_result(board)
  if winner?(board)
    puts "Winner is #{determine_winner(board)}!"
  else
    puts "It is a tie"
  end
end

# ============= MAIN PROGRAMME ===================

start_game

loop do # game loop
  board = initialize_board
  display_board(board)

  loop do # 1 round loop
    player = player_choice(board)
    board[player] = PLAYER_MARK
    break if winner?(board) || tie?(board)

    computer = available_moves(board).sample
    board[computer] = COMPUTER_MARK
    display_board(board)

    break if winner?(board) || tie?(board)
  end

  display_board(board)
  display_result(board)

  break if play_again? == "n"
end

puts "Thank you"
