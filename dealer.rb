class Dealer < Player

  def initialize
    super("Dealer")
    @shoe = Shoe.new
  end

  def deal(players)
    2.times do
      players.each do |player|
        player.hand << @shoe.take_card if player.bet > 0
      end
      hand << @shoe.take_card
    end
  end

  def hit(player)
    player.hand << @shoe.take_card
  end

  def show
    hand[0]
  end

  def play
    while status == :ready
      if hand_total < 17
        hit(self)
      else
        @stand = true
      end
    end
  end

  def winners(players)
    winning_players = []
    players.each do |player|
      if status == :bust && player.status != :bust
        winning_players << player
      elsif player.hand_total > hand_total && player.status != :bust
        winning_players << player
      elsif player.hand_total == hand_total && player.status != :bust
        push(player)
      end
    end

    winning_players.each { |player| payout(player) }
    consolidate_split_hands(winning_players)
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

  def split_hand(player, split_player)
    split_player.hand << player.hand.pop
    split_player.bet = player.bet
    player.stack -= player.bet
    hit(player)
    hit(split_player)
  end

  def consolidate_split_hands(winning_players)
    winning_players.each do |player|
      if player.class == SplitPlayer
        player.parent.stack += (player.stack-STARTING_STACK)
      end
    end
  end

end
