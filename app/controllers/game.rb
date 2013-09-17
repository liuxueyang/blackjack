class Game
  include View
  attr_reader :dealer
  attr_accessor :players

  def initialize
    View.clear_screen!
    View.welcome
    @dealer = Dealer.new
    @players = []
    View.ask_players
    num_players = gets.chomp.to_i
    View.clear_screen!
    num_players.times do |i|
      @players << Player.new("Player #{i+1}")
    end
  end

  def play
    place_bets
    dealer.deal(players)
    play_hands
    dealer_play
    determine_winners
    reset
    next_round
  end

  def place_bets
    players.each do |player|
      next if player.stack <= 0
      bet = -1
      until bet >= 0 && bet <= player.stack
        View.ask_bet(player.name,player.stack)
        bet = gets.chomp.to_i
        View.no_money if bet > player.stack
        View.no_bet if bet == 0
      end
      player.bet = bet
      player.stack -= bet
    end
  end

  def play_hands
    players.each do |player|
      next if player.bet == 0
      View.clear_screen!
      View.summary(player.name,player.hand,player.display_total)
      while player.status == :ready do
        View.dealer_showing(dealer.show)
        options = player.play_options
        action = ""
        until options.include?(action)
          View.action(options.join(", "))
          action = gets.chomp
        end

        case action
        when "stand"
          player.stand = true
        when "hit"
          dealer.hit(player)
          View.summary(player.name,player.hand,player.display_total)
        when "double"
          player.double_bet
          dealer.hit(player)
          player.stand = true
          View.summary(player.name,player.hand,player.display_total)
        when "split"
          split_player = SplitPlayer.new(player.name+" second hand",player)
          dealer.split_hand(player,split_player)
          index = players.find_index(player)+1
          players.insert(index, split_player)
          View.summary(player.name,player.hand,player.display_total)
        else
          raise "Player action not found"
        end
      end

      View.end_turn(STATUS_MESSAGE[player.status])
      gets

    end
  end

  def dealer_play
    View.clear_screen!
    dealer.play
    View.summary(dealer.name,dealer.hand,dealer.display_total)
  end

  def determine_winners
    winning_players = dealer.winners(players)
    players.each do |player|
      result = winning_players.include?(player) ? "WON!" : "did not win."
      View.announce_result("won!",player.name,player.stack)
    end
  end

  def reset
    players.each do |player|
      players.delete(player) if player.class == SplitPlayer
      player.hand.clear
      player.bet = 0
      player.stand = false
    end
  end

  def playing_again
    playing_again = []
    players.each do |player|
      response = ""
      until response == "y" || response == "n"
        View.play_again(player.name)
        response = gets.chomp
      end
      if response == "n"
        View.cash_out(player.stack)
      elsif response == "y" && player.stack > 0
        playing_again << player
      else
        View.no_money
      end
    end
    playing_again
  end

  def next_round
    players = playing_again
    if players.length > 0
      play
    else
      View.goodbye
    end
  end
end
