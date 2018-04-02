
class Entity

    @@sprite404 : SF::Sprite = get_sprite("default")

    @sprite     : SF::Sprite
    @world      : World

    @width  : Int32
    @height : Int32

    property x      : Float64,
             y      : Float64,
             xmom   : Float64,
             ymom   : Float64,
             width  : Int32,
             height : Int32,
             facingright : Bool


    def initialize(@world)
        # sets the default sprite
        @sprite = @@sprite404.dup

        # x and y momentum, other variables can influence speed,
        # but this allows other objects to easily read others speeds
        @xmom = 0.0
        @ymom = 0.0

        # x and y position of the entity,
        # this is measured from the center of the sprite, not the top left corner.
        # this makes game physics harder but drawing the sprites and hitboxes easier.
        @x      = 0.0
        @y      = 0.0

        # dimensions of the sprite as it should appear on the screen
        # setting sprite height is a bad idea though, it is automatically set
        # accoriding to sprite width in order to remove any stretching/squeezing
        # of the texture
        @sprite_width = 0
        @sprite_height = 0

        # is the sprite facing right?
        @facingright = false

        # dimensions of the hitbox
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
    def frame(x) : Nil
        @sprite.texture_rect = SF::IntRect.new(@framewidth * x,0,@framewidth,@frameheight)
    end

    # adds entity to the world's projectile list
    def join_world : Nil
      @world.projectiles << self
    end

    # sets the current frame based off of elapsed time
    def animate(loops = true)
        frame = @world.clock.elapsed_time.as_milliseconds * @framespeed / 1000.0
        resizeSprite
        if (loops || frame < @frames)
            frame(frame.to_i % @frames)
        end
    end


    # updates sprite to fit height to the sprite width given
    def resizeSprite
        xscale  = @sprite_width * 1.0  / @framewidth
        @sprite_height = (xscale * @frameheight).to_i
        # need o reverse x if facing left
        @sprite.scale = SF.vector2(@facingright ? xscale : -xscale,xscale);
    end

    # a method to take key input
    def input(key)
    end

    # a method to draw the sprite
    def draw()
        @sprite.position = SF.vector2((@x + (@facingright ? -@sprite_width : @sprite_width)/2).to_i,(@y - @sprite_height / 2).to_i)
        @world.as(Game).drawsprite @sprite
    end

    # this is called each game tick
    # if it returns false the game loop deletes the entity
    def tick()
        true
    end

    # would this entity clip(collide with the 'level' 'tile's) at the given coords?
    def clips(x, y)
        @world.get_level.clips(x - @width / 2, y - @height / 2, x + @width / 2, y + @height / 2)
    end

    # loads an image from the resourses folder
    # and returns it. this method is static,
    # so it can be called in any class to get any image
    def self.get_sprite(name) : SF::Sprite
        sprite = SF::Sprite.new
        sprite.texture =  SF::Texture.from_file("./resources/"+name+".png")
        return sprite
    end
end
