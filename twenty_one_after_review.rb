
LOW_ACE_VALUE = 1
HIGH_ACE_VALUE = 11
FINAL_SCORE = 5
score = { dealer: 0, player: 0 }

# Methods for initialization

def start_game
  system "clear"
  puts
  puts ">>> WELCOME TO TWENTY-ONE <<<"
  puts "Who wins #{FINAL_SCORE} games, is winner"
  puts
  puts "Enter to start"
  gets
end

def receive_shuffled_deck
  deck = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace] * 4
  deck.shuffle
end

def initial_deal!(deck)
  player_hand = deck.pop(1)
  dealer_hand = deck.pop(2) + ["?"]
  [player_hand, dealer_hand]
end

# Methods for display/interaction

def display_cards(hand)
  s = hand.size
  puts
  puts "  ----- " * s
  puts " |     |" * s
  puts hand.map { |card| " |" + card.to_s.center(5) + "|" }.join
  puts " |     |" * s
  puts "  ----- " * s
end

def display_hand(who, hand, score)
  puts "#{who.to_s.upcase}"
  is_covered = hand.include? "?"
  hand = cover_last_card(hand) if is_covered
  display_cards(hand)
  puts "Hand: #{sum_cards(hand)}" unless is_covered
  puts
end

def display_both_players(score, player_hand, dealer_hand)
  system "clear"
  display_hand(:dealer, dealer_hand, score)
  display_hand(:player, player_hand, score)
  puts "---------------------"
  puts "Dealer:Player #{score[:dealer]}:#{score[:player]}"
  puts "---------------------"
end

def check_player_choice
  loop do
    puts "(H)it or (S)tay?"
    choice = gets.chomp.strip.downcase
    return choice if choice == "s" || choice == "h"
    puts "Sorry, not a valid choice. Try again."
  end
end

def check_finish?(score)
  return true if get_winner(score)
  loop do
    puts
    puts "Press Enter to continue, 'Q' to quit"
    choice = gets.chomp.downcase
    return true if choice == "q" || choice == "quit"
    return false if choice == ""
    puts "Sorry, not a valid choice. Try again."
  end
end

def finish_game(score)
  winner = get_winner(score).to_s.capitalize
  puts
  puts "#{winner} won the game." unless winner.empty?
  puts "Game over. Thanks for playing."
end

# Methods for card manipulation

def cover_last_card(hand)
  covered_hand = hand.dup
  covered_hand.delete_at(-2)
  covered_hand
end

def take_card!(hand, deck)
  hand << deck.pop
end

def turn_hidden_card!(hand)
  hand.pop
end

# Methods for game logic / evaluation

def player_stays?(choice)
  choice == "s"
end

def card_value(card, ace_value)
  return card.to_i unless card.to_i == 0
  case card
  when "Ace"
    ace_value
  else
    10
  end
end

def sum_cards(hand)
  high_value = hand.reduce(0) do |memo, card|
    memo + card_value(card, HIGH_ACE_VALUE)
  end
  low_value = hand.reduce(0) do |memo, card|
    memo + card_value(card, LOW_ACE_VALUE)
  end
  high_value > 21 ? low_value : high_value
end

def busted?(hand)
  sum_cards(hand) > 21
end

def increment(score, who)
  score[who] += 1
end

def evaluate_not_busted!(score, dealer_hand, player_hand)
  case sum_cards(dealer_hand) <=> sum_cards(player_hand)
  when 1
    increment(score, :dealer)
    "Dealer wins."
  when -1
    increment(score, :player)
    "Player wins."
  else
    "It's a draw."
  end
end

def evaluate_play!(score, dealer_hand, player_hand)
  result = if busted?(player_hand)
             increment(score, :dealer)
             "You have busted. Dealer wins."
           elsif busted?(dealer_hand)
             increment(score, :player)
             "Dealer has busted. Player win."
           else
             evaluate_not_busted!(score, dealer_hand, player_hand)
           end
  display_both_players(score, player_hand, dealer_hand)
  puts result
end

def get_winner(score)
  score.key(FINAL_SCORE)
end

# MAIN PROGRAM

deck = receive_shuffled_deck
start_game

# Game
loop do
  player_hand, dealer_hand = initial_deal!(deck)

  # Player's turn
  loop do
    take_card!(player_hand, deck)
    display_both_players(score, player_hand, dealer_hand)
    break if busted?(player_hand) || player_stays?(check_player_choice)
  end

  # Dealer's turn
  unless busted?(player_hand)
    turn_hidden_card!(dealer_hand)
    loop do
      break if busted?(dealer_hand) || sum_cards(dealer_hand) > 17
      take_card!(dealer_hand, deck)
    end
    display_both_players(score, player_hand, dealer_hand)
  end

  # Evaluation
  evaluate_play!(score, dealer_hand, player_hand)
  break if check_finish?(score)
end
finish_game(score)
