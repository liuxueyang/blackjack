module View
  extend self

  def clear_screen!
    print "\e[2J"
    print "\e[H"
  end

  def welcome
    puts <<-LOGO
   ___  __         __     _          __
  / _ )/ /__ _____/ /__  (_)__ _____/ /__
 / _  / / _ `/ __/  '_/ / / _ `/ __/  '_/
/____/_/\\_,_/\\__/_/\\_\\_/ /\\_,_/\\__/_/\\_\\
                    |___/
By Patrick Moody
-----------------------------------------
Welcome to Blackjack!
    LOGO
  end

  def ask_players
    puts "How many players?"
  end

  def ask_bet(name,stack)
    puts "#{name} stack: $#{stack}\nEnter bet amount (whole number):"
  end

  def no_money
    puts "You don't have enough money!"
  end

  def no_bet
    puts "No bet placed this game"
  end

  def summary(player)
    puts "====== #{player.name} ======"
    puts "Cards:"
    player.hand.each { |card| puts "   #{card}" }
    puts "----------------------"
    puts "Hand total: #{player.display_total}"
    puts
  end

  def dealer_showing(card)
    puts "Dealer is showing:"
    puts "   #{card}"
    puts
  end

  def action(options)
    puts "Choose enter of the following: #{options.join(", ")}"
  end

  def end_turn(status)
    puts status
    puts "Press enter to continue"
  end

  def announce_result(result,name,total,stack)
    puts "#{name} #{result} Hand: #{total}, New stack: $#{stack}"
  end

  def play_again(name)
    puts "#{name}, play again? ('y' or 'n')"
  end

  def cash_out(stack)
    puts "You cashed out with $#{stack}"
  end

  def goodbye
    puts "Thanks for playing!"
  end
end
