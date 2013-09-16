require 'config'
require 'card'
require 'shoe'
require 'player'
require 'dealer'



# Clear the screen and move cursor
def clear_screen!
  print "\e[2J"
  print "\e[H"
end

# Setup
clear_screen!
players = []
puts "Welcome to Blackjack!"
puts "How many players?"
num_players = gets.chomp.to_i
clear_screen!
num_players.times do |i|
  players << Player.new("Player #{i+1}")
end


module Game
  # Place bets
  # -------------------------
  def self.play(players)
    dealer = Dealer.new
    place_bets(players)
    dealer.deal(players)
    play_hands(dealer,players)
    dealer_play(dealer)
    determine_winners(dealer,players)
  end

  def self.place_bets(players)
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
  end

  # Deal players
  # -------------------------
  # dealer.deal(players)

  # Players take turn playing
  # -------------------------
  def self.play_hands(dealer,players)
    players.each do |player|
      next if player.bet == 0
      clear_screen!
      puts player.summary
      while player.status == :ready do
        puts "Dealer is showing #{dealer.show}"
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
          puts player.summary
        when "double"
          player.double_bet
          dealer.hit(player)
          player.stand = true
          puts player.summary
        when "split"
          split_player = SplitPlayer.new(player.name+" second hand",player)
          split_player.hand << player.hand.pop
          split_player.bet = player.bet
          player.stack -= player.bet
          dealer.hit(player)
          dealer.hit(split_player)
          index = players.find_index(player)+1
          players.insert(index, split_player)
          puts player.summary
        else
          raise "Player action not found"
        end
      end

    puts STATUS_MESSAGE[player.status]

    puts "Press enter to continue"
    gets
    end
  end

  def self.dealer_play(dealer)
    clear_screen!
    puts dealer.play # add check for dealer blackjack
  end


  # Determine and announce winners
  # -------------------------
  def self.determine_winners(dealer,players)
    winning_players = dealer.winners(players) # add secret sauce for split hands
    if winning_players.length == 0
      puts "No winners"
    else
      winning_players.each do |player|
        puts "#{player.name} wins! Stack: $#{player.stack}"
      end
    end
  end

end

Game::play(players)


