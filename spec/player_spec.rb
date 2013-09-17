require 'spec_helper'

describe Player do
  subject { Player.new("Test Player") }

  describe '#double_bet' do
    it 'doubles the bet amount' do
      subject.bet = 10
      subject.double_bet
      subject.bet.should == 20
    end

    it 'reduces stack' do
      subject.bet = 10
      subject.double_bet
      subject.stack.should == STARTING_STACK - 10
    end
  end

  describe '#hand_total' do
    it 'correct total without ace' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}
      subject.hand_total.should == 8
    end

    it 'assumes aces = 11 if total under 21' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','Ace',1)]}
      subject.hand_total.should == 14
    end

    it 'assumes aces = 1 if total over 21' do
      subject.stub(:hand) {[Card.new('Hearts','10',10),Card.new('Hearts','Ace',1),Card.new('Hearts','Jack',10)]}
      subject.hand_total.should == 21
    end
  end

  describe '#display_total' do
    it 'shows readable total' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}
      subject.display_total.should == '8'
    end

    it 'shows two options with ace' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','Ace',1)]}
      subject.display_total.should == '4 or 14'
    end

    it 'shows 1 option with ace and total over 21' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','Ace',1),Card.new('Hearts','Jack',10)]}
      subject.display_total.should == '14'
    end
  end

  describe '#has_ace?' do
    it 'true for ace in hand' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','Ace',1)]}
      subject.has_ace?.should == true
    end

    it 'false for no ace' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}
      subject.has_ace?.should == false
    end
  end

  describe '#status' do
    it 'is :ready for starting hand' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}
      subject.status.should == :ready
    end

    it 'is :stand when stand = true' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}
      subject.stand = true
      subject.status.should == :stand
    end

    it 'is :bust for hand_total over 21' do
      subject.stub(:hand_total) {22}
      subject.status.should == :bust
    end

    it 'is :blackjack for starting hand' do
      subject.stub(:hand_total) {21}
      subject.stub(:hand) {[1,1]}
      subject.status.should == :blackjack
    end

  end

  describe '#play_options' do
    it 'only hit and stand by default' do
      subject.play_options.should == ["hit","stand"]
    end

    it 'can double on first hand' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5)]}
      subject.play_options.should == ["hit","stand","double"]
    end

    it 'cant double after first hand' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Hearts','5',5),Card.new('Hearts','6',6)]}
      subject.play_options.should == ["hit","stand"]
    end

    it 'can split and double when first hand is pairs' do
      subject.stub(:hand) {[Card.new('Hearts','3',3),Card.new('Clubs','3',3)]}
      subject.play_options.should == ["hit","stand","double","split"]
    end
  end

end

describe SplitPlayer do
  subject {SplitPlayer.new("Test Player",Player.new("Test Parent"))}

  it 'has a parent player' do
    subject.parent.class == Player
  end
end
