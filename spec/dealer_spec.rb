require 'spec_helper'

describe Dealer do

  subject { Dealer.new }
  before(:each) do
    @player = Player.new("Test Player")
    @player.bet = 10
    @players = [@player]
  end

  describe '#deal' do
    it 'gives players 2 cards' do
      subject.deal(@players)
      @players[0].hand.length.should == 2
    end

    it 'only deals if player has bet' do
      @player.bet = 0
      subject.deal(@players)
      @players[0].hand.length.should == 0
    end
  end

  describe '#hit' do
    it 'gives player a new card' do
      card = Card.new('Hearts','3',3)
      subject.shoe.stub(:take_card){card}
      subject.hit(@player)
      @player.hand[0].should == card
    end
  end

  describe '#show' do
    it 'reveals dealers first card' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}
      subject.show.to_s.should == "3 of Hearts"
    end
  end

  describe '#winners' do
    it 'skips player if they havent bet' do
      @player.bet = 0
      subject.winners(@players).should == []
    end

    it 'returns winning player when dealer bust' do
      @player.stub(:status){:stand}
      subject.stub(:status){:bust}
      subject.winners(@players).should == @players
    end

    it 'returns winning player higher total than dealer' do
      @player.stub(:status){:stand}
      @player.stub(:hand_total){20}
      subject.stub(:status){:stand}
      subject.stub(:hand_total){19}
      subject.winners(@players).should == @players
    end

    it 'returns empty when nobody wins' do
      @player.stub(:status){:stand}
      @player.stub(:hand_total){15}
      subject.stub(:status){:stand}
      subject.stub(:hand_total){19}
      subject.winners(@players).should == []
    end
  end

  describe '#payout' do
    it 'pays out regular win' do
      @player.stub(:status){:stand}
      subject.payout(@player)
      @player.stack.should == 1020
    end

    it 'pays out blackjack' do
      @player.stub(:status){:blackjack}
      subject.payout(@player)
      @player.stack.should == 1030
    end
  end

  describe '#push' do
    it 'adds bet back to player stack' do
      subject.push(@player)
      @player.stack.should == 1010
    end
  end

  describe '#split_hand' do
    before(:each) {@player.hand = [Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}

    it 'distributes cards' do
      @split_player = SplitPlayer.new("Split Test",@player)
      second_card = @player.hand[1]
      subject.split_hand(@player,@split_player)
      @split_player.hand[0].should == second_card
    end

    it 'hits original hand' do
      @split_player = SplitPlayer.new("Split Test",@player)
      subject.split_hand(@player,@split_player)
      @player.hand.length.should == 2
    end

    it 'hits split hand' do
      @split_player = SplitPlayer.new("Split Test",@player)
      subject.split_hand(@player,@split_player)
      @split_player.hand.length.should == 2
    end

  end

  describe '#consolidate_split_hands' do

    it 'adds split players winnings to parent player' do
      @player.stack = 1200
      @split_player = SplitPlayer.new("Split Test",@player)
      @split_player.stack = 1200
      subject.consolidate_split_hands([@player,@split_player])
      @player.stack.should == 1400
    end
  end

end
