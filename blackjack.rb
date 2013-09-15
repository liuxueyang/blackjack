require 'pp'

STARTING_STACK = 1000

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
    @cards.pop
  end

end


class Player
  attr_reader :name
  attr_accessor :hand, :stack, :stand

  def initialize(name)
    @name = name
    @hand = []
    @stack = STARTING_STACK
    @stand = false
  end

  def hand_total
    total = 0
    @hand.each do |card|
      total += card.value
    end
    total
  end

  def summary
    summary = "==== #{@name} ====\n"
    @hand.each do |card|
      summary += "#{card.to_s}\n"
    end
    summary += "----------\nTotal: #{hand_total}\n#{status}\n"
  end

  def status
    if hand_total == 21 && @hand.length == 2
      :blackjack
    elsif hand_total == 21 || @stand == true
      :stand
    elsif hand_total < 21
      :ready
    else hand_total > 21
      :bust
    end
  end
end

class Dealer
  def initialize
    @deck = Deck.new
    @hand = []
  end

  def deal(players)
    2.times do
      players.each do |player|
        player.hand << @deck.take_card
      end
      @hand << @deck.take_card
    end
  end

  def hit(player)
    player.hand << @deck.take_card
  end

end



#=========== METHODS TO GO IN A MODULE? ================


def play(player)
  turn
  dealer_play
  declare_winners
end

def turn
  # player is prompted to action until they are finished
end

def dealer_play
  # Dealer plays according to rules to finish game
end

def declare_winners
  # Check status of players and dealer to establish winners
end
#=======================================================


# Driver Code
# ============

# Setup
players = []
puts "Welcome to Blackjack!"
puts "How many players?"
num_players = gets.chomp.to_i
num_players.times do |i|
  players << Player.new("Player #{i+1}")
end

dealer = Dealer.new
dealer.deal(players)

players.each do |player|
  puts player.summary
  while player.status == :ready do
    action = ""
    until action == "h" || action == "s"
      puts "Hit or stand? (type 'h' or 's')"
      action = gets.chomp
    end
    player.stand = true if action == 's'
    dealer.hit(player) if action == 'h'
    puts player.summary
  end

  if player.status == :blackjack
    puts "Blackjack!"
  elsif player.status == :bust
    puts "Bust!"
  elsif player.status == :stand
    puts "Stand."
  else
    raise "Unexpected player status"
  end
end

dealer_play
declare_winners


