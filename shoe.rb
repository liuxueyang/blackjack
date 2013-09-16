class Shoe
  attr_reader :cards

  def initialize
    @cards = []
    fill_shoe
    @cards.shuffle!
  end

  def fill_shoe
    NUMBER_OF_DECKS.times do
      generate_deck
    end
  end

  def generate_deck
    %w{Spades Clubs Hearts Diamonds}.each do |suit|
      cards << Card.new(suit, 'Ace', 1)
      2.upto(10) { |i| cards << Card.new(suit, i.to_s, i) }
      %w{Jack Queen King}.each { |picture| cards << Card.new(suit, picture, 10) }
    end
  end

  def take_card
    raise "No cards left in deck!" if cards.length == 0
    cards.pop
  end

end
