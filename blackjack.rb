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

puts "   ___  __         __     _          __  "
puts "  / _ )/ /__ _____/ /__  (_)__ _____/ /__"
puts " / _  / / _ `/ __/  '_/ / / _ `/ __/  '_/"
puts "/____/_/\\_,_/\\__/_/\\_\\_/ /\\_,_/\\__/_/\\_\\ "
puts "                    |___/"


puts "Welcome to Blackjack!"
puts "How many players?"
num_players = gets.chomp.to_i
clear_screen!
num_players.times do |i|
  players << Player.new("Player #{i+1}")
end

Game::play(players)


