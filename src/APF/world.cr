
# the most basic instance of the environment
# keeps up with projectiles and calls tick on them.
class World
    property projectiles  : Array(Entity),
             level        : Level | Nil,
             clock        : SF::Clock

    def initialize()
        # create a clock to keep track of time.
        @clock       = SF::Clock.new
        # Entity.tick is called on each of these elements every World.tick.
        @projectiles = [] of Entity
        # this is the environment, the tiles in other words.
        @level       = Level.new self
    end

    # should be treated as an abstract method, is merely here
    # so that it can be easiliy swaapped out for 'Game'
    # in some casses
    def key_input(key, down : Bool)
    end

    # tick each projectile
    def tick()
        @projectiles = @projectiles.select do |projectile|
            projectile.tick
        end
    end

    # this is here for the same reason that key_input is here,
    # read that comment for info
    def drawsprite(sprite)
    end

    # getter method for @level because it is "nillable" so it has to be cast
    # as a level each time its used so this makes it a lot easier (less boilerplatey).
    def get_level
        level.as(Level)
    end
end
