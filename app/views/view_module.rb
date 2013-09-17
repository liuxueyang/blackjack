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
    puts "#{name} stack: $#{stack}\nEnter bet amount (whole number or 0):"
  end



end
