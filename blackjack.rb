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
  attr_accessor :hand, :stack, :status

  def initialize(name)
    @name = name
    @hand = []
    @stack = STARTING_STACK
    @status = :ready
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
    summary += "Total: #{hand_total}\n"

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

end



#=========== METHODS TO GO IN A MODULE? ================
def get_action(player)
  # Prompt user to hit or stand
end

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
  action = get_action(player)
  # game.action if player.status != :stand || :bust
end

dealer_play
declare_winners



puts players[0].summary

