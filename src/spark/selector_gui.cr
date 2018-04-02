require "bcsg"
require "./game_gui"
require "./game/*"
class Selector_GUI < GUI
  def initialize(window)
    super window, "selector_gui"
    self.create
  end

  def get_resource(name : String) : String
     "./resources/gui/" + name
  end

  def should_close : Bool
    return @bools["start"]
  end
  
  def close 
    game = case @strings["type"] 
           when "online"
             Peer.new(@window)
           when "offline"
             Game.new(@window)
           end
    puts @strings["type"]
    puts game 
    ret = Game_GUI.new(@window, game.nil? ? Game.new(@window) : game)
    ret.create
    return ret
  end
end 
