=begin

1. Initialize deck
2. Deal cards to player and dealer
3. Player turn: hit or stay
  - repeat until bust or "stay"
4. If player bust, dealer wins.
5. Dealer turn: hit or stay
  - repeat until total >= 17
6. If dealer bust, player wins.
7. Compare cards and declare winner.

=end

NUM_OF_CARDS_TO_DEAL = 2
ACE_LOWER_VALUE = 1
ACE_HIGHER_VALUE = 10

def initialize_deck
  (%w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace] * 4).shuffle
end

def display_hands(player_hand, dealer_hand, all_cards_visible)
  system "clear"
  display_hand(dealer_hand, "DEALER:", all_cards_visible)
  display_hand(player_hand, "PLAYER:", true)
end

def display_hand(hand, message, all_cards_visible)
  hand_with_covered = if all_cards_visible
                        hand
                      else
                        hand[0..-2] << "???"
                      end
  formatted_hand = hand_with_covered.map { |card| card.center(7) }.join("|")
  puts message
  puts
  puts " #{'------- ' * hand.size}"
  puts "|#{'       |' * hand.size}"
  puts "|#{formatted_hand}|"
  puts "|#{'       |' * hand.size}"
  puts " #{'------- ' * hand.size}"
  puts
end

def deal_card(hand, deck)
  hand << deck.pop
end

def player_decision
  choice = nil
  loop do
    puts "(H)it or (S)tay?"
    choice = gets.chomp.strip.downcase
    break if choice == "h" || choice == "s"
    puts "Sorry, I do not understand your move."
  end
  choice == "h" ? "hit" : "stay"
end

def busted?(hand)
  compute_hand_two_values(hand).min > 21
end

def dealer_takes_cards(hand, deck)
  while compute_hand_two_values(hand).max < 17
    deal_card(hand, deck)
  end
end

def compute_hand_two_values(hand)
  [compute_hand(hand, ACE_HIGHER_VALUE), compute_hand(hand, ACE_LOWER_VALUE)]
end

def compute_hand(hand, ace_value)
  hand.reduce(0) do |memo, card|
    if card.to_i > 0
      memo + card.to_i
    elsif %w[Jack Queen King].include? card
      memo + 10
    else
      memo + ace_value
    end
  end
end

def determine_winner(dealer_hand, player_hand)
  dealer_sum = if compute_hand_two_values(dealer_hand).max > 21
                 compute_hand_two_values(dealer_hand).min
               else
                 compute_hand_two_values(dealer_hand).max
               end
  player_sum = if compute_hand_two_values(player_hand).max > 21
                 compute_hand_two_values(player_hand).min
               else
                 compute_hand_two_values(player_hand).max
               end
  case dealer_sum <=> player_sum
  when -1 then "Player"
  when 1 then "Computer"
  else nil
  end
end

def display_result(winner)
  if winner
    puts "#{winner} won."
  else
    puts "It's a tie"
  end
end

# --- GAME ---

deck = initialize_deck
dealer_hand = deck.pop(NUM_OF_CARDS_TO_DEAL)
player_hand = deck.pop(NUM_OF_CARDS_TO_DEAL)

loop do
  display_hands(player_hand, dealer_hand, false)

  break if busted?(player_hand) || player_decision == "stay"
  deal_card(player_hand, deck)
end

if busted?(player_hand)
  puts "You have busted. Dealer wins."
else
  dealer_takes_cards(dealer_hand, deck)
  display_hands(player_hand, dealer_hand, true)
  if busted?(dealer_hand)
    puts "Dealer busted. You win."
  else
    winner = determine_winner(dealer_hand, player_hand)
    display_result(winner)
  end
end
