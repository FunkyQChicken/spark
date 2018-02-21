
class World
    property projectiles  : Array(Entity),
             players      : Array(Player),
             level        : Level | Nil,
             clock        : SF::Clock

    def initialize()

        @clock       = SF::Clock.new
        @projectiles = [] of Entity
        @players     = [] of Player
        @level       = Level.new self
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

    def drawsprite(sprite)
    end

    # getter method for @level because it is "nillable" so it has to be cast
    # as a level each time its used so this makes it a lot easier.
    def get_level
        level.as(Level)
    end

end
