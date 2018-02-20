
class Player < Entity
  # the various player animations
    @@crouching : SF::Sprite = get_sprite("player/crouching")
    @@standing  : SF::Sprite = get_sprite("player/idling")
    @@walking   : SF::Sprite = get_sprite("player/walking")
    @@running   : SF::Sprite = get_sprite("player/running")
    @@jumping   : SF::Sprite = get_sprite("player/jumping")
    @@falling   : SF::Sprite = get_sprite("player/falling")

  # default player controls
    @@controls = {SF::Keyboard::Key::D => :right,
                  SF::Keyboard::Key::A => :left,
                  SF::Keyboard::Key::S => :down,
                  SF::Keyboard::Key::W => :up,
                  SF::Keyboard::Key::J => :primary,
                  SF::Keyboard::Key::K => :secondary
                 }

  # variables that need to be assigned a type
    @controls : Hash(SF::Keyboard::Key,Symbol)
    def initialize(@game)
        super
      # these variables are documented in Entity class.
        @x = 100.0
        @y = 100.0
        @framewidth  = 64
        @frameheight = 64
        @framespeed  = 10
        @width       = 15
        @height      = 60
        @sprite_width = 67
        anim :wal
        resizeSprite

      # set the default controls
        @controls = @@controls.dup

      # are you going right?
        @right = false
      # are you going left?
        @left = false
      # holding left key?
        @lefthold = false
      # holding right key?
        @righthold = false
      # are you holding down the spacebar?
        @space = false
      # are you airborne?
        @air = true

      # the maximum speed in the ground and air
        @max_speed = 8.0

      # the higher it is the slower the speedup, 0 is instantanious
        @accel_facor_ground = 5.0
        @accel_facor_air    = 20.0

      # if your airborn we store your xmom when you left the ground a continue to add it on top
      # of your new xmom
        @ground_to_air_xmom = 0.0

      # gravity variables, despite the different name format,
      # gravity is calculated exactly the same way as movement.
        @max_fall_speed = 25.0
      # this is equivalent to accel_factor but for falling, this is
      # factor used when you are holding down the spacebar.
        @fall_factor_jump = 70.1
      # this is the same as @fall_factor_jump, except it is used when you aren't
      # holding down the spacebar.
        @fall_factor_norm = 50.1

      # the speed of your ymom when you jump,
        @jump_speed = -12.0
      # number of jumps you have between hitting the ground
        @max_jumps = 3
      # current number of used jumps
        @used_jumps = 0

      # if true then the player will jump next tick if able to and set this to false.
        @jump = false
      # this is just to keep track if the jump key has been relesed so that then

      # these are the
        @primary = Teleport.new(self, @game)
        @primary_activate = false
        @secondary = Ability.new(self, @game)
        @secondary_activate = false
    end

    def tick : Bool
      # process @jump if its true and jump if possible
        if @jump
            if @used_jumps < @max_jumps
                @used_jumps += 1
                @ymom = @jump_speed
                @air = true
            end
            @jump = false
        end

      # cast/activate abilities if needed
        if @primary_activate
          @primary.as(Ability).activate
          @primary_activate  = false
        end
        if @secondary_activate
          @secondary.as(Ability).activate
          @secondary_activate = false
        end

      # acceleration factor and the max speed
        speed = @max_speed
        accel = @air ? @accel_facor_air : @accel_facor_ground
      # pick the gravity based on weather or not your holding down the jump key
        fallaccel = @space ? @fall_factor_jump : @fall_factor_norm
        @ymom = ((@ymom * fallaccel) + @max_fall_speed) / (fallaccel + 1)
      # going to the left means that you want to be going negative
        speed *= -1 if @left
      # update x momentum based of acceleration factor and if they are trying to move
        @xmom = @right || @left ? ((@xmom * accel) + speed)/(accel + 1) : (@xmom * accel) / (accel + 1)

      # calculate the new coords,
        newx = @xmom + @ground_to_air_xmom + @x
        newy = @ymom + @y
      # apply them if they don't run into anything
        if clips(@x, newy)
            if @ymom > 0
                @air = false
                @used_jumps = 0
            end
            @ground_to_air_xmom = 0.0
            @ymom = 0.0
        else
            if @used_jumps < 1
                @used_jumps = 1
            end
            @air = true
            @y = newy
        end
        if clips(newx, @y)
            @xmom = 0.0
        else
            @x = newx
        end

        return super
    end

    def input(key, down)
        return if ! @controls.has_key? key
        case @controls[key]
        when :primary
          @primary_activate = true
        when :secondary
          @secondary_activate = true
        when :up
            @jump = !@space
            @space = down
        when :down

        when :left
            if down
                return if @lefthold
                @right = false
                @left = true
                @lefthold = true
            else
                @right = @righthold
                @lefthold = false
                @left = false
            end
        when :right
            if down
                return if @righthold
                @left = false
                @right = true
                @righthold = true
            else
                @left = @lefthold
                @righthold = false
                @right = false
            end
        end
    end

    # these just make it easier to change anim frames.
    # this holds the textures for each animation
    @@anims : Hash(Symbol, SF::Sprite) =
              {:cro => @@crouching, :sta => @@standing, :wal => @@walking,
               :run => @@running  , :jum => @@jumping , :fal => @@falling}
    # this holds the number of frames for each animation
    @@frames: Hash(Symbol, Int32) =
              {:cro => 1, :sta => 6, :wal => 8,
               :run => 8, :jum => 3, :fal => 3}
    def draw
        if @xmom != 0
            @facingright = @xmom > 0
        end
        if !@right && !@left
           anim(:sta)
        elsif @xmom.abs > @max_speed - 0.25
           anim(:run)
        else
           anim(:wal)
        end
        animate
        super
    end

    def anim(code : Symbol)
        @sprite = @@anims[code]
        @frames = @@frames[code]
    end
end
