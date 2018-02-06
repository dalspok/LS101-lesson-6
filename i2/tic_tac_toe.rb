require "pry"

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                 [1, 4, 7], [2, 5, 8], [3, 6, 9],
                 [1, 5, 9], [3, 5, 7]]
FINAL_VALUE = 5
score = {"Player" => 0, "Computer" => 0}

def display_board(brd, score)
  system "clear"
  puts
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |"
  puts
  puts "Player: #{score["Player"]} - Computer: #{score["Computer"]}"
end

def joinor(arr, join_by = ", ", join_last = "or")
  return arr.join(" " + join_last + " ") if arr.size < 3
  arr[0..-2].join(join_by) + join_by + join_last + " "+ arr[-1].to_s
end

def initialize_board
  brd = {}
  (1..9).each { |num| brd[num] = INITIAL_MARKER }
  brd
end

def empty_squares(brd)
  brd.keys.select { |key| brd[key] == INITIAL_MARKER }
end

def player_places_piece(brd)
  choice = ""
  loop do
    puts "What is your choice? (#{joinor empty_squares(brd)})"
    choice = gets.chomp.to_i
    break if empty_squares(brd).include? choice
    puts "Sorry, that's not a valid choice"
    puts
  end
  brd[choice] = PLAYER_MARKER
end

def computer_places_piece(brd)
  key = if third_in_a_row(brd, COMPUTER_MARKER)
          third_in_a_row(brd, COMPUTER_MARKER)
        elsif third_in_a_row(brd, PLAYER_MARKER)
          third_in_a_row(brd, PLAYER_MARKER)
        else
          empty_squares(brd).sample
        end
  brd[key] = COMPUTER_MARKER
end

def third_in_a_row(brd, marker)
  WINNING_LINES.each do |line|
    markers_in_row = [brd[line[0]], brd[line[1]], brd[line[2]]].count(marker)
    empty_markers_in_row = [brd[line[0]], brd[line[1]], brd[line[2]]].count(INITIAL_MARKER)
    if markers_in_row == 2 && empty_markers_in_row == 1
      return line[line.index {|brd_key| brd[brd_key] == INITIAL_MARKER}]
    end
  end
  nil
end

def defense_move(brd)
  WINNING_LINES.each do |line|
    player_markers_in_row = [brd[line[0]], brd[line[1]], brd[line[2]]].count(PLAYER_MARKER)
    empty_markers_in_row = [brd[line[0]], brd[line[1]], brd[line[2]]].count(INITIAL_MARKER)
    if player_markers_in_row == 2 && empty_markers_in_row == 1
      return line[line.index {|brd_key| brd[brd_key] == INITIAL_MARKER}]
    end
  end
  nil
end

def offense_move(brd)
  WINNING_LINES.each do |line|
    computer_markers_in_row = [brd[line[0]], brd[line[1]], brd[line[2]]].count(COMPUTER_MARKER)
    empty_markers_in_row = [brd[line[0]], brd[line[1]], brd[line[2]]].count(INITIAL_MARKER)
    if computer_markers_in_row == 2 && empty_markers_in_row == 1
      return line[line.index {|brd_key| brd[brd_key] == INITIAL_MARKER}]
    end
  end
  nil
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def update_score(score, brd)
  score[detect_winner(brd)] += 1 if someone_won?(brd)
end

def final_winner(score)
  score.key FINAL_VALUE
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd[line[0]] == PLAYER_MARKER && brd[line[1]] == PLAYER_MARKER &&
       brd[line[2]] == PLAYER_MARKER
      return "Player"
    elsif brd[line[0]] == COMPUTER_MARKER && brd[line[1]] == COMPUTER_MARKER &&
          brd[line[2]] == COMPUTER_MARKER
      return "Computer"
    end
  end
  nil
end

loop do
  board = initialize_board

  loop do
    display_board(board, score)

    player_places_piece(board)
    break if someone_won?(board) || board_full?(board)

    computer_places_piece(board)
    break if someone_won?(board) || board_full?(board)
  end

  update_score(score, board)
  display_board(board, score)
  if someone_won?(board)
    puts "#{detect_winner(board)} won."
  else
    puts "It's a tie"
  end
  puts "(Enter - continue)"
  gets

  break if final_winner(score)
end
puts "Final winner is: #{final_winner(score)}"
puts "Thank's for playing."
