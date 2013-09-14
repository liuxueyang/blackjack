require 'rspec'
require './blackjack'

describe Card do
  subject { Card.new('Hearts','3',3) }

  it 'has readable suit' do
    subject.suit.should == 'Hearts'
  end

  it 'has readable face' do
    subject.face.should == '3'
  end

  it 'has readable value' do
    subject.value.should == 3
  end

end


describe Deck do
  subject { Deck.new }

  context 'after creation' do
    it 'has 52 cards' do
      subject.cards.count.should == 52
    end
  end

  describe '#take_card' do
    it 'returns a unique card' do
      card = subject.take_card
      subject.cards.include?(card).should == false
    end
  end

end


describe Player do
  subject { Player.new }

end



describe Dealer do

  subject { Dealer.new }

  describe '#deal' do
    it 'gives players 2 cards' do
      players = [Player.new]
      subject.deal(players)
      players[0].hand.length.should == 2
    end
  end

  describe '#showing' do
    it 'reveals dealers first card' do
      subject.deal([])
      subject.showing.class.should == Card
    end
  end
end
