class Card
  attr_reader :suit, :face, :value
  def initialize(suit, face, value)
    @suit = suit
    @face = face
    @value = value
  end

  def is_ace?
    face == "Ace"
  end

  def to_s
    "#{face} of #{suit}"
  end
end
