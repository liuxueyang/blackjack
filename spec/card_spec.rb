require 'spec_helper'

describe Card do
  subject { Card.new('Hearts','3',3) }

  context 'readable attributes' do
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

  describe '#is_ace?' do
    it 'returns false for non-ace cards' do
      subject.is_ace?.should == false
    end

    it 'returns true for ace cards' do
      test_ace = Card.new('Hearts','Ace',1)
      test_ace.is_ace?.should == true
    end
  end

  describe '#to_s' do
    it 'returns a readable description of card' do
      subject.to_s.should == "3 of Hearts"
    end
  end
end
