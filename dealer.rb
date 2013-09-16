class Dealer
  def initialize
    @shoe = Shoe.new
    @dealer_player = Player.new("Dealer")
  end

  def deal(players)
    2.times do
      players.each do |player|
        player.hand << @shoe.take_card if player.bet > 0
      end
      @dealer_player.hand << @shoe.take_card
    end
  end

  def hit(player)
    player.hand << @shoe.take_card
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
