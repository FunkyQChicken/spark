require "./game/*"
require "bcsg"

class Game_GUI < GUI
  def initialize(window, game : Game)
    super window, "game_gui"
    @game = game 
  end

  def draw
    @game.draw 
  end

  def tick
    @game.tick
    super
  end 
  
  def key_input(char : String, down : Bool)
    @game.key_input(char, down)
  end

  def get_resource(name : String) : String
     "./resources/gui/" + name
  end
end 
