require 'spec_helper'

describe Shoe do

  NUMBER_OF_DECKS = 2
  subject { Shoe.new }

  context 'after creation' do
    it 'has 104 cards for 2 decks' do
      subject.cards.count.should == 104
    end
  end

  describe '#fill_shoe' do
    it 'creates decks of cards to fill shoe' do
      pending
    end
  end

  describe '#generate_deck' do
    it 'creates a deck of unique cards' do
      pending
    end
  end

  describe '#take_card' do
    it 'returns a unique card for 1 deck' do
      card = subject.take_card
      subject.cards.include?(card).should == false
    end
  end

end
