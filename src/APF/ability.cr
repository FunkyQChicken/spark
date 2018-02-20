# this is the ability calss, an ability is an attack that is contained
# by a player.
class Ability
  @lastcast : Int32
  def initialize(@player : Player, @game : Game)
    @lastcast = @game.clock.elapsed_time.as_milliseconds
    @cooldown = 0
  end

  def activate
  end

  def on_cooldown?
    return @game.clock.elapsed_time.as_milliseconds - @lastcast < @cooldown
  end

  def reset_cooldown
    @lastcast = @game.clock.elapsed_time.as_milliseconds
  end
end

class Teleport < Ability
  def initialize(player, game)
    super
    @cooldown = 1000
    @game.get_level.tilewidth
    @range = 500
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
