class Player
  attr_reader :name
  attr_accessor :hand, :stack, :stand, :bet, :parent

  def initialize(name)
    @name = name
    @hand = []
    @stack = STARTING_STACK
    @stand = false
    @bet = 0
  end

  def double_bet
    @stack -= bet
    @bet = bet*2
  end

  def hand_total
    raise "No cards in hand" if hand.length == 0

    total = hand.map(&:value).reduce(:+)
    if has_ace? && total <= 11
      total += 10
    end
    total
  end

  def display_total
    total = hand.map(&:value).reduce(:+)
    if has_ace? && total < 11
      "#{total} or #{total+10}"
    elsif has_ace? && total == 11
      "#{total+10}"
    else
      "#{total}"
    end
  end

  def has_ace?
    hand.each { |card| return true if card.is_ace? }
    return false
  end

  def status
    if hand_total == 21 && hand.length == 2
      :blackjack
    elsif hand_total > 21
      :bust
    elsif hand_total == 21 || stand == true
      :stand
    elsif hand_total < 21
      :ready
    else
      raise "Unknown status error"
    end
  end

  def play_options
    options = ["hit","stand"]
    if hand.length == 2 && stack > bet
      options << "double"
      if hand[0].face == hand[1].face
        options << "split"
      end
    end
    options
  end
end


class SplitPlayer < Player
  attr_reader :parent

  def initialize(name,parent)
    super(name)
    @parent = parent
  end
end
