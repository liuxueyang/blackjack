# Extend Kernel module to include 'require_relative' method for ruby 1.8.7
# Source: https://github.com/appoxy/aws/blob/master/lib/awsbase/require_relative.rb

unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require 'rspec'
require_relative '../config/environment'

STARTING_STACK = 1000
NUMBER_OF_DECKS = 2
STATUS_MESSAGE = {:blackjack => "Blackjack!",
                  :ready => "Waiting for action...",
                  :stand => "Stand",
                  :bust => "Bust hand!"}

RSpec.configure do |config|
  config.order = "random"
end
