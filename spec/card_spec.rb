require 'spec_helper'

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

  describe '#is_ace?' do
    it 'returns true for ace cards' do
      pending
    end
  end

  describe '#to_s' do
    it 'returns a readable description of card' do
      pending
    end
  end
end
