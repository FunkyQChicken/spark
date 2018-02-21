class World
  property projectiles  : Array(Entity),
           players      : Array(Player),
           level        : Level | Nil,
           clock        : SF::Clock

  def initialize
      # used to keep track of elapsed time
      @clock       = SF::Clock.new
      # projectiles on the map
      @projectiles = [] of Entity
      # players on the map
      @players     = [] of Player
      # the level
      @level       = Level.new self
      # the game window that is drawn to
  end


  def key_input(key, down : Bool)
      @players.each do |player|
          player.input(key, down)
      end
  end


  def tick()
      @players = @players.select do |player|
          player.tick
      end
      @projectiles = @projectiles.select do |projectile|
          projectile.tick
      end
  end

  # getter method for @level because it is "nillable" so it has to be cast
  # as a level each time its used so this makes it a lot easier.
  def get_level
      level.as(Level)
  end
end
