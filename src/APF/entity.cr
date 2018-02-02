require "crsfml"

class Entity
    
    @@sprite404 : SF::Sprite = get_sprite("default") 
    
    @sprite     : SF::Sprite
    @game       : Game

    def initialize(@game)
        @sprite : SF::Sprite = @@sprite.dup
        
        @xmom = 0
        @ymom = 0
        
        @x      = 0
        @y      = 0
        @width  = 0
        @height = 0
    end

    def input(key)
    end

    def draw()
        @sprite.position = SF.vector2(@x,@y)
        @game.window.draw @sprite 
    end

    def tick()
        @x += @xmom
        @y += @ymom
    end

    def self.get_sprite(name)
        SF::Sprite.new(SF::Texture.from_file("./recources/"+name+".png"))
    end
end
