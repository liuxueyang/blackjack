require 'config'
require 'card'
require 'shoe'
require 'player'
require 'dealer'
require 'helpers'
require 'game_module'

# Setup
clear_screen!
players = []

puts open("logo.txt").read
puts "Welcome to Blackjack!"
puts "How many players?"
num_players = gets.chomp.to_i
clear_screen!
num_players.times do |i|
  players << Player.new("Player #{i+1}")
end

Game::play(players)


