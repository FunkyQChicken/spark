
class Test < Entity
    @@texture :  SF::Sprite = get_sprite("test")
    def initialize(game) 
        super
        @x = 420.0
        @y = 220.0
        @width = 300
        @height = 300
        @sprite = @@texture
        @framewidth = 64
        @frameheight = 64
        @framespeed = 10
        @frames = 6
        resizeSprite
    end

    def draw
       animate
       super
    end
end 
   
