module Game

  def self.play(players)
    dealer = Dealer.new
    place_bets(players)
    dealer.deal(players)
    play_hands(dealer,players)
    dealer_play(dealer)
    determine_winners(dealer,players)
    reset(players)
    next_round(players)
  end

  def self.place_bets(players)
    players.each do |player|
      next if player.stack <= 0
      puts "#{player.name} stack: $#{player.stack}\nEnter bet amount (whole number or 0):"
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
          dealer.split_hand(player,split_player)
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
    dealer.play
    puts dealer.summary
  end

  def self.determine_winners(dealer,players)
    winning_players = dealer.winners(players)
    players.each do |player|
      if winning_players.include?(player)
        puts "#{player.name} won! Stack: $#{player.stack}"
      else
        puts "#{player.name} no win. Stack: $#{player.stack}"
      end
    end
  end

  def self.reset(players)
    players.each do |player|
      players.delete(player) if player.class == SplitPlayer
      player.hand.clear
      player.bet = 0
      player.stand = false
    end
  end

  def self.playing_again(players)
    playing_again = []
    players.each do |player|
      response = ""
      until response == "y" || response == "n"
        puts "#{player.name}, play again? ('y' or 'n')"
        response = gets.chomp
      end
      if response == "n"
        puts "You cashed out with $#{player.stack}"
      elsif response == "y" && player.stack > 0
        playing_again << player
      else
        puts "You're out of money!"
      end
    end
    playing_again
  end

  def self.next_round(players)
    next_round_players = playing_again(players)
    if next_round_players.length > 0
      play(next_round_players)
    else
      puts "Thanks for playing!"
    end
  end



end
