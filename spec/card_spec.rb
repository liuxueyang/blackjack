require 'spec_helper'

describe Card do
  subject { Card.new('Hearts','3',3) }

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
