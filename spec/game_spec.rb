require 'spec_helper'

describe Game do

  subject { Game.new([Player.new("Player 1"),Player.new("Player 2")]) }

  describe '#play' do
    it 'starts a game' do
      pending
    end
  end

  describe '#place_bets' do
    it 'gets bets for players' do
      pending
    end
  end

  describe '#play_hands' do
    it 'completes players card play' do
      pending
    end
  end

  describe '#dealer_play' do
    it 'completes dealers turn' do
      pending
    end
  end

  describe '#determine_winners' do
    it 'pay out winners' do
      pending
    end
  end

  describe '#reset' do
    it 'removes bets and stand status' do
      pending
    end
  end

  describe '#playing_again' do
    it 'gets players for next round' do
      pending
    end
  end

  describe '#next_round' do
    it 'start game again if players' do
      pending
    end

    it 'dont restart game if no players' do
      pending
    end
  end

end
