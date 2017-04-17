
LOW_ACE_VALUE = 1
HIGH_ACE_VALUE = 11
DEALER = :Dealer
PLAYER = :Player
DRAW = "Draw"
score = {Dealer: 0, Player: 0}

def get_shuffled_deck
  deck = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace) * 4
  deck.shuffle
end

def initial_deal
  deck = get_shuffled_deck
  player_hand = deck.pop(1)
  dealer_hand = deck.pop(2) + ["?"]
  [player_hand, dealer_hand, deck]
end

def turn_hidden_card!(hand)
  hand.pop
end

def take_card!(hand, deck)
  hand << deck.pop
end

def get_player_choice
  loop do
    puts "(H)it or (S)tay?"
    choice = gets.chomp.strip.chr.downcase
    return choice if choice == "s" || choice == "h"
    puts "Sorry, not a valid choice. Try again."
  end
end

def player_stays?(choice)
  return choice == "s"
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

def card_value(card, ace_value)
  return card.to_i unless card.to_i == 0
  case card
  when "Ace"
    ace_value
  else
    10
  end
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
      increment(score, DEALER)
      "Dealer wins."
    when -1
      increment(score, PLAYER)
      "Player wins."
    else
      "It's a draw."
    end‚
end


def evaluate_game!(score, dealer_hand, player_hand)
  result = if busted?(player_hand)
            increment(score, DEALER)
            "You have busted. Dealer wins."
          elsif busted?(dealer_hand)
            increment(score, PLAYER)
            "Dealer has busted. You win."
          else
            evaluate_not_busted!(score, dealer_hand, player_hand)
          end
  display_both_players(score, player_hand, dealer_hand)
  display_game_results(result)
end

def display_game_results(message)
  puts message
end

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
  puts "#{who.to_s.upcase}(#{score[who]}):"
  is_covered = hand.include? "?"
  hand = cover_last_card(hand) if is_covered
  display_cards(hand)
  puts "Hand: #{sum_cards(hand)}" unless is_covered
  puts
end

def display_both_players(score, player_hand, dealer_hand)
  system "clear"
  display_hand(DEALER, dealer_hand, score)
  display_hand(PLAYER, player_hand, score)
end

def cover_last_card(hand)
  covered_hand = hand.dup
  covered_hand.delete_at(-2)
  return covered_hand
end

# MAIN PROGRAM

player_hand, dealer_hand, deck = initial_deal

loop do      # Player's turn
  take_card!(player_hand, deck)
  display_both_players(score, player_hand, dealer_hand)
  break if busted?(player_hand) || player_stays?(get_player_choice)
end

unless busted?(player_hand)   # Dealer's turn
  turn_hidden_card!(dealer_hand)
  loop do
    break if busted?(dealer_hand) || sum_cards(dealer_hand) > 17
    take_card!(dealer_hand, deck)
  end
  display_both_players(score, player_hand, dealer_hand)
end

evaluate_game!(score, dealer_hand, player_hand)




