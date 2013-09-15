STARTING_STACK = 1000
STATUS_MESSAGE = {:blackjack => "Blackjack!", :ready => "Waiting for action...", :stand => "Stand", :bust => "Bust hand!"}

class Card
  attr_reader :suit, :face, :value
  def initialize(suit, face, value)
    @suit = suit
    @face = face
    @value = value
  end

  def is_ace?
    @face == "Ace"
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

  def double_bet
    @stack -= @bet
    @bet = @bet*2
  end

  def hand_total
    total = @hand.map(&:value).reduce(:+)
    if has_ace? && total <= 11
      total += 10
    end
    total
  end

  def display_total
    total = @hand.map(&:value).reduce(:+)
    if has_ace? && total < 11
      total += 10
      total == 21 ? total.to_s : "#{total-10} or #{total}"
    else
      total.to_s
    end
  end

  def summary
    @hand.reduce("====== #{@name} ======\n"){ |memo,card| memo + "#{card}\n" } +
    "----------\nTotal: #{display_total}\n#{status}\n"
  end

  def has_ace?
    @hand.each { |card| return true if card.is_ace? }
    return false
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

  def play_options
    options = ["hit","stand"]
    if @hand.length == 2 && @stack > @bet
      options << "double"
      if @hand[0].face == @hand[1].face
        options << "split"
      end
    end
    options
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
    players.each do |player|
      if @dealer_player.status == :bust && player.status != :bust
        winning_players << player
      elsif player.hand_total > @dealer_player.hand_total && player.status != :bust
        winning_players << player
      elsif player.hand_total == @dealer_player.hand_total && player.status != :bust
        push(player)
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
  next if player.stack <= 0
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
    options = player.play_options
    action = ""
    until options.include?(action)
      puts "Choose one of the following: #{options.join(", ")}"
      action = gets.chomp
    end

    case action
    when "stand"
      player.stand = true
    when "hit"
      dealer.hit(player)
    when "double"
      player.double_bet
      dealer.hit(player)
      player.stand = true
    when "split"
      # Do stuff
    else
      raise "Player action not found"
    end
  end

  puts player.summary
  puts STATUS_MESSAGE[player.status]

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
    puts "#{player.name} wins! Stack: $#{player.stack}"
  end
end



