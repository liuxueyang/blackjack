require 'spec_helper'

describe Shoe do

  subject { Shoe.new }

  describe '#fill_shoe' do
    it 'creates 2 decks of cards to fill shoe' do
      subject.cards.count.should == 104
    end
  end

  describe '#generate_deck' do
    it 'creates a deck of unique cards' do
      deck = subject.generate_deck
      deck.length.should == deck.uniq.length
    end

    it 'creates a deck of 52 cards' do
      subject.generate_deck.count.should == 52
    end
  end

  describe '#take_card' do
    it 'returns a unique card for 1 deck' do
      card = subject.take_card
      subject.cards.include?(card).should == false
    end
  end

end
