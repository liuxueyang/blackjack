require 'config'
require 'card'
require 'shoe'
require 'player'
require 'dealer'
require 'helpers'
require 'game'

puts open("logo.txt").read
puts "Welcome to Blackjack!"


blackjack = Game.new
blackjack.play


