require 'spec_helper'

describe Dealer do

  subject { Dealer.new }

  describe '#deal' do
    it 'gives players 2 cards' do
      players = [Player.new("Test Player")]
      players[0].bet = 10
      subject.deal(players)
      players[0].hand.length.should == 2
    end

    it 'only deals if player has bet' do
      players = [Player.new("Test Player")]
      players[0].bet = 0
      subject.deal(players)
      players[0].hand.length.should == 0
    end
  end

  describe '#hit' do
    it 'gives player a new card' do
      # player = double()
      # player.stub(:hand){[]}
      # shoe = double()
      # shoe.stub(:take_card){"card"}
      # subject.hit(player)
      # player.hand.should_receive("card")
    end
  end

  describe '#show' do
    it 'reveals dealers first card' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}
      subject.show.to_s.should == "3 of Hearts"
    end
  end

  describe '#play' do
    it 'does_this' do
      pending
    end
  end

  describe '#winners' do
    it 'does_this' do
      pending
    end
  end

  describe '#payout' do
    it 'does_this' do
      pending
    end
  end

  describe '#push' do
    it 'adds bet back to player stack' do
      # player =g double
      # player.stub(:stack) {10}
      # player.stub(:bet) {10}
      # subject.push(player).should == 20
    end
  end

  describe '#split_hand' do
    it 'does_this' do
      pending
    end
  end

  describe '#consolidate_split_hand' do
    it 'does_this' do
      pending
    end
  end

end
