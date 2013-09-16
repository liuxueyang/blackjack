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
  end

  describe '#hit' do
    it 'does_this' do
      pending
    end
  end

  describe '#show' do
    it 'reveals dealers first card' do
      pending
    end
  end

  describe '#plauy' do
    it 'does_this' do
      pending
    end
  end

  describe '#summary' do
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
    it 'does_this' do
      pending
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
