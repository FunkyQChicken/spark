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
    @range = 10
  end

  def activate
    if !on_cooldown?
      reset_cooldown
    else
      return
    end
    @player.x = 100.0
  end
end
