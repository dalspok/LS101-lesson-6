

CARD_VALUES = (2..10).map(&:to_s) + %w[J Q K A]

def initialize_deck
  (CARD_VALUES * 4).shuffle
end

def initialize_game
  deck = initialize_deck
  player = []
  dealer = []
  [deck, player, dealer]
end

def deal_player!(dealer, deck, cards = 1)
  (dealer << deck.pop(cards)).flatten!
end

def deal_dealer!(player, deck, cards = 1)
  (player << deck.pop(cards)).flatten!
end

def count_hand(person)
  higher_value = person.map do |card|
    %w[J Q K A].include?(card) ? 10 : card.to_i
  end
                       .sum

  lower_value = person.map do |card|
    case card
    when "J", "Q", "K" then 10
    when "A" then 1
    else card.to_i
    end
  end
                      .sum
  higher_value > 21 ? lower_value : higher_value
end

def busted?(person)
  count_hand(person) > 21
end

def dealer_choose!(dealer, deck)
  until count_hand(dealer) >= 17
    deal_dealer!(dealer, deck)
  end
end

def display(player, dealer)
  system "clear"
  puts "Player: (#{count_hand(player)})"
  display_cards(player)
  puts
  puts "Dealer: (#{count_hand(dealer)})"
  display_cards(dealer)
  puts
end

def display_covered(player, _)
  system "clear"
  puts "Player: (#{count_hand(player)})"
  display_cards(player)
  puts
  puts "Dealer:"
  display_cards(["?", "?"])
  puts
end

def display_cards(hand)
  puts " ----- " * hand.size
  puts "|     |" * hand.size
  puts hand.map { |card| "|  #{card.center(2)} |" }.join
  puts "|     |" * hand.size
  puts " ----- " * hand.size
end

def determine_winner(player, dealer)
  return "Draw" if count_hand(player) == count_hand(dealer)
  count_hand(player) > count_hand(dealer) ? "Player" : "Dealer"
end

def player_choice
  choice = ""
  loop do
    puts "(H)it or (S)tay?"
    choice = gets.chomp.downcase
    break if %w[h s hit stay].include? choice
    puts "Incorrect choice. Please try again."
    puts
  end
  choice == "h" ? :hit : :stay
end

def display_winner(player, dealer)
  if busted?(player)
    puts "Player busted, dealer wins."
  elsif busted?(dealer)
    puts "Dealer busted, player wins."
  elsif determine_winner(player, dealer) == "Draw"
    puts "It's a draw."
  else
    puts "#{determine_winner(player, dealer)} wins."
  end
end

def play_again?
  puts
  puts "Do you want to play again? (y/n)"
  choice = 'nil'
  loop do
    choice = gets.chomp.downcase
    break if %w[y n].include? choice
    puts "Incorrect choice, please try again."
  end
  choice == "y"
end

loop do
  system "clear"
  deck, player, dealer = initialize_game

  deal_player!(player, deck, 2)
  deal_dealer!(dealer, deck, 2)
  display_covered(player, dealer)

  until busted?(player) || player_choice == :stay
    deal_player!(player, deck)
    display_covered(player, dealer)
  end

  if !busted?(player)
    dealer_choose!(dealer, deck)
  end

  display(player, dealer)
  display_winner(player, dealer)
  break unless play_again?
end

puts "Thanks for playing!"
