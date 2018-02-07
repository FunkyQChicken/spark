
class Entity
    
    @@sprite404 : SF::Sprite = get_sprite("default") 
    
    @sprite     : SF::Sprite
    @game       : Game

    @width  : Int32 
    @height : Int32

    def initialize(@game)
        # sets the default sprite 
        @sprite = @@sprite404.dup
       
        # x and y momentum, other variables can influence speed, 
        # but this allows other objects to easily read others speeds 
        @xmom = 0.0
        @ymom = 0.0
        
        # x and y position of the entity,
        # this is measured form the center of the sprite, not the top left corner.
        # this makes game physics easier but drawing the sprites a little harder
        @x      = 0.0
        @y      = 0.0

        # dimensions of the sprite as it should appear on the screen
        @width  = 0
        @height = 0
       
        # animation variables,
        # the number of frames in the animation 
        @frames = 0
        # the width of each frame frame, not the entire spritesheet.
        @framewidth  = 0
        # the heigth of each frame
        @frameheight = 0
        # the speed in fps that you want the animation to run in
        @framespeed  = 0
        # the time the current animation started, relevant for non looping anim.s
        @animstart   = 0
    end
   
    # sets the frame according to 
    # framelength and frameheight
    def frame(x)
        @sprite.texture_rect = SF::IntRect.new(@framewidth * x,0,@framewidth,@frameheight)
    end 
   
    # sets the current frame based off of elapsed time 
    def animate(loops = true)
        frame = @game.clock.elapsed_time.as_milliseconds * @framespeed / 1000.0
        if (loops || frame < @frames)   
            frame(frame.to_i % @frames)
        end
    end


    # resizes sprite and height to fit the current width 
    def resizeSprite
        xscale  = @width * 1.0  / @framewidth
        yscale  = @height * 1.0 / @frameheight
        @sprite.scale = SF.vector2(xscale,yscale);
    end

    # a method to take key input
    def input(key)
    end

    # a method to draw the sprite
    def draw()
        @sprite.position = SF.vector2(@x.to_i-(@width/2),@y.to_i-(@height/2))
        @game.drawsprite @sprite
    end

    # this is called each game tick, if it returns false the game loop deletes it
    def tick()
        true
    end

    # loads an image from the resourses folder
    # and returns it. this method is static, 
    # so it can be called in any class to get any image
    def self.get_sprite(name) : SF::Sprite
        sprite = SF::Sprite.new
        sprite.texture =  SF::Texture.from_file("./recources/"+name+".png")
        return sprite
    end
end
