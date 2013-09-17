unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require './app/models/card'
require './app/models/shoe'
require './app/models/player'
require './app/models/dealer'
require './app/views/view_module'
require './app/controllers/game'
