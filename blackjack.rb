require 'pp'

STARTING_STACK = 1000

class Card
  attr_reader :suit, :face, :value
  def initialize(suit, face, value)
    @suit = suit
    @face = face
    @value = value
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
  attr_accessor :hand, :stack

  def initialize
    @hand = []
    @stack = STARTING_STACK
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

  def showing
    @hand[0]
  end

end


class Game
  def initialize(players)
    @dealer = Dealer.new
    @players = players
    @dealer.deal(players)
  end

end


# Driver Code
# ============


players = []
puts "Welcome to Blackjack!"
puts "How many players?"
num_players = gets.chomp
num_players.times do
  players << Player.new
end
game = Game.new(players)

