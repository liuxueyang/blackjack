require 'pp'

STARTING_STACK = 1000

# Card = Struct.new(:suit, :face, :value) do
#   def to_s
#     "#{face} of #{suit}"
#   end
# end

class Card
  attr_reader :suit, :face, :value
  def initialize(suit, face, value)
    @suit = suit
    @face = face
    @value = value
  end

  def to_s
    "#{@face} of #{@suit}"
  end

end

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    generate_cards
    @cards.shuffle!
  end

  def generate_cards
    suits = ['Spades','Clubs','Hearts','Diamonds']
    suits.each do |suit|
      @cards << Card.new(suit, 'Ace', 1)

      2.upto(10) do |i|
        @cards << Card.new(suit, i.to_s, i)
      end

      pictures = ['Jack', 'Queen', 'King']
      pictures.each do |picture|
        @cards << Card.new(suit, picture, 10)
      end
    end
  end

  def take_card
    raise "No cards left in deck!" if @cards.length == 0
    @cards.pop
  end

end


class Player
  attr_reader :name
  attr_accessor :hand, :stack, :stand, :bet

  def initialize(name)
    @name = name
    @hand = []
    @stack = STARTING_STACK
    @stand = false
    @bet = 0
  end

  def hand_total
    @hand.map(&:value).reduce(:+)
  end

  def summary
    @hand.reduce("====== #{@name} ======\n"){ |memo,card| memo + "#{card}\n" } +
    "----------\nTotal: #{hand_total}\n#{status}\n"
  end

  def status
    if hand_total == 21 && @hand.length == 2
      :blackjack
    elsif hand_total > 21
      :bust
    elsif hand_total == 21 || @stand == true
      :stand
    elsif hand_total < 21
      :ready
    else
      raise "Unknown status error"
    end
  end
end

class Dealer
  def initialize
    @deck = Deck.new
    @dealer_player = Player.new("Dealer")
  end

  def deal(players)
    2.times do
      players.each do |player|
        player.hand << @deck.take_card
      end
      @dealer_player.hand << @deck.take_card
    end
  end

  def hit(player)
    player.hand << @deck.take_card
  end

  def show
    @dealer_player.hand[0]
  end

  def play
    while @dealer_player.status == :ready
      hit(@dealer_player) if @dealer_player.hand_total < 17
      @dealer_player.stand = true if @dealer_player.hand_total >= 17
    end
    @dealer_player.summary
  end

  def winners(players)
    winning_players = []
    if @dealer_player.status == :bust
      players.each { |player| winning_players << player if player.status != :bust }
    else
      players.each do |player|
        if player.hand_total > @dealer_player.hand_total && player.status != :bust
          winning_players << player
        elsif player.hand_total == @dealer_player.hand_total && player.status != :bust
          push(player)
        end
      end
    end

    winning_players.each { |player| payout(player) }
    winning_players
  end

  def payout(player)
    if player.status == :blackjack
      player.stack += player.bet*3
    else
      player.stack += player.bet*2
    end
  end

  def push(player)
    player.stack += player.bet
  end


end


# Clear the screen and move cursor
def clear_screen!
  print "\e[2J"
  print "\e[H"
end


# Driver Code
# ============

# Setup
clear_screen!
players = []
puts "Welcome to Blackjack!"
puts "How many players?"
num_players = gets.chomp.to_i
num_players.times do |i|
  players << Player.new("Player #{i+1}")
end

clear_screen!

dealer = Dealer.new
dealer.deal(players)

# Place bets
# -------------------------
players.each do |player|
  puts "#{player.name} - $#{player.stack}\nEnter bet amount (whole number or 0):"
  bet = -1
  until bet >= 0 && bet <= player.stack
    bet = gets.chomp.to_i
    puts "You don't have enough money! Enter new amount" if bet > player.stack
    puts "No bet placed this game" if bet == 0
  end
  player.bet = bet
  player.stack -= bet
end


# Players take turn playing
# -------------------------
players.each do |player|
  next if player.bet == 0
  clear_screen!
  while player.status == :ready do
    puts "Dealer is showing #{dealer.show}"
    puts player.summary
    action = ""
    until action == "h" || action == "s"
      puts "Hit or stand? (type 'h' or 's')"
      action = gets.chomp
    end
    player.stand = true if action == 's'
    dealer.hit(player) if action == 'h'
  end

  # if player.status == :blackjack
  #   puts "Blackjack!"
  # elsif player.status == :bust
  #   puts "Bust!"
  # elsif player.status == :stand
  #   puts "Stand."
  # else
  #   raise "Unexpected player status"
  # end

  puts "Hit enter to continue"
  gets
end

clear_screen!
puts dealer.play



# Determine and announce winners
# -------------------------
winning_players = dealer.winners(players)
if winning_players.length == 0
  puts "No winners"
else
  winning_players.each do |player|
    puts "#{player.name} wins! Balance: $#{player.stack}"
  end
end



