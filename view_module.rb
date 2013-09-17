module View
  extend self

  def clear_screen!
    print "\e[2J"
    print "\e[H"
  end



end
