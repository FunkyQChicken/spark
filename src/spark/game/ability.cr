require "./entity.cr"

# this is the ability calss, an ability is an attack that is contained
# by a player.
class Ability
  # the last time the ability was cast, usefull for cooldowns.
  @last_cast : Int32

  def initialize(@player : Player, @world : World)
    @last_cast = time
    @cooldown = 0
  end

  def activate : Nil
    puts ["ka-pow!","bam!","zing!","blamo!","poof!","*sputter*"][rand(6)]
  end

  def on_cooldown?
    time - @last_cast < @cooldown
  end

  # returns the current time is as_milliseconds
  # just makes the code look neater (less boilerplatey)
  def time
    @world.clock.elapsed_time.as_milliseconds
  end

  # IDEA: remove as is really simple
  # sets last cast to now
  def reset_cooldown : Nil
    @last_cast = time
  end

  # takes a string and returns an ability with that class name
  # constructed with the given world and player.
  def self.get_ability(str, player, world) : Ability
    return case str
    when "Ability"
      Ability
    when "Teleport"
      Teleport
    when "FireBall"
      FireBall
    else
      Ability
    end.new(player, world)
  end
end






# teleport to a random location around you.
class Teleport < Ability
  def initialize(player, game)
    super
    @cooldown = 1000
    @range = 1000
  end

  def get_random_coord
    rand(@range) - (@range / 2)
  end

  def activate
    if !on_cooldown?
      reset_cooldown
    else
      return
    end
    newx = 0
    newy = 0
    while true
      newx = get_random_coord + @player.x
      newy = get_random_coord + @player.y
      break if !@player.clips(newx,newy)
    end
    @player.x = newx
    @player.y = newy
  end
end






class FireBall < Ability
  # short for projectile
  class Proj < Entity
    def initialize(world,@player : Player)
        super(world)
        @x    = @player.x
        @y    = @player.y
        # technically this 'facing right' is actually keeping track of 'facing left'
        # but im too lazy to change the texture... ill just add a todo
        # TODO: fix the texture
        @facingright = !@player.facingright
        @sprite = Entity.get_sprite("abilities/fireball")
        # the speed of the projectile
        @xmom = 10.0

        # reverse momentum if facig the other way
        @xmom *= -1 if @facingright
        @xmom += player.xmom/2
        # animation/texture settings, see Entity for documentation
        @sprite_width = 25

        # dimensions of the hitbox
        @width  = 20
        @height = 6

        # TODO: make an animation, not just a static image for the fireball
        # animation variables, documented in Entity class
        @frames = 0 #irrelevant currently
        @framewidth  = 15
        @frameheight = 15
        @framespeed  = 0 #irrelevant currently

        frame(0)

        join_world
    end

    def draw
      resizeSprite
      super
    end

    def tick
      @x += @xmom
      return super
    end
  end

  @max_time : Int32
  def initialize(player, world)
    super
    @time_accumulated = 0
    # cooldown per shot
    @mini_cooldown = 1000
    # the number of charges that can be built up
    @num_of_casts = 4
    # the maximum that time_accumulated is allowed to be
    @max_time = @num_of_casts * @mini_cooldown
  end

  def activate : Nil
    # add time since last cast to time_accumulated and cut it off
    # if it is above the allowed maximum
    @time_accumulated += (time - @last_cast)
    if @time_accumulated > @max_time
      @time_accumulated = @max_time
    end
    return if @time_accumulated < @mini_cooldown
    @last_cast = time
    @time_accumulated -= @mini_cooldown
    Proj.new(@world, @player)
  end
end
