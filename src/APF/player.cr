
class Player < Entity
    @@crouching : SF::Sprite = get_sprite("player/crouching") 
    @@standing  : SF::Sprite = get_sprite("player/idling")   
    @@walking   : SF::Sprite = get_sprite("player/walking") 
    @@running   : SF::Sprite = get_sprite("player/running")  
    @@jumping   : SF::Sprite = get_sprite("player/jumping")   
    @@falling   : SF::Sprite = get_sprite("player/falling")
    
    def initialize(@game)
        super
        @x = 300.0
        @y = 100.0
        @framewidth = 43
        @frameheight = 43
        @framespeed = 10
        @width       = 60
        @height      = 60
        anim :wal
        resizeSprite

         
        # are you going right?
        @right = false
        # are you going left?
        @left = true
        # are you airborne?
        @air = false

        # the maximum speed on the ground/air
        @max_speed_air      = 0.0
        @max_speed_ground   = 10.0
        # the higher it is the slower the speedup, 0 is instantanious
        @accel_facor_ground = 5.0
        @accel_facor_air  = 0.5
    end

    def tick : Bool
      # acceleration factor and the max speed
        accel = @accel_facor_ground
        speed = @max_speed_ground
      # if your in the air we need to update the accel and speed
        if @air
            accel = @accel_facor_air
        end
      # going to the left means that you want to be going negative
        speed *= -1 if @left 
      # update x momentum based of acceleration factor and if they are trying to move
        @xmom = if @right || @left
                    ((@xmom * accel) + speed)/(accel + 1)
                else
                    (@xmom * accel) / (accel + 1)
                end
      # apply the x momentum 
        @x += @xmom
        return super
    end

    @@anims : Hash(Symbol, SF::Sprite) = 
              {:cro => @@crouching, :sta => @@standing, :wal => @@walking,
               :run => @@running  , :jum => @@jumping , :fal => @@falling}
    @@frames: Hash(Symbol, Int32) =
              {:cro => 1, :sta => 1, :wal => 8,
               :run => 3, :jum => 3, :fal => 3}
    def draw 
        animate
        super
    end        
    
    def anim(code : Symbol) 
        @sprite = @@anims[code]
        @frames = @@frames[code]
    end   
end
