class Dealer < Player
  attr_reader :shoe

  def initialize
    super("Dealer")
    @shoe = Shoe.new
  end

  def deal(players)
    2.times do
      players.each do |player|
        player.hand << shoe.take_card if player.bet > 0
      end
      hand << shoe.take_card
    end
  end

  def hit(player)
    player.hand << shoe.take_card
  end

  def show
    hand[0]
  end

  def winners(players)
    winning_players = []
    players.each do |player|
      next if player.bet == 0 || player.status == :bust
      if status == :bust
        winning_players << player
      elsif player.hand_total > hand_total
        winning_players << player
      elsif player.hand_total == hand_total
        push(player)
        consolidate_split_hands([player])
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
