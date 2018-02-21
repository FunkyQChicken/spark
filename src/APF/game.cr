
class Game
    property window       : SF::RenderWindow,
             projectiles  : Array(Entity),
             players      : Array(Player),
             level        : Level | Nil,
             clock        : SF::Clock

    def initialize(@window)
        @window_center = [0,0]
        @winwow_height = 400
        @transform     = SF::Transform.new

        @clock       = SF::Clock.new
        @projectiles = [] of Entity
        @players     = [] of Player
        @level       = Level.new self
        @window      = window
        play = Player.new self
        @players << play
        #@projectiles << Test.new self
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

    def gen_transform()
      @transform = SF::Transform.new
      @transform.rotate(10)
    end

    def draw()
        gen_transform()
        @projectiles.each do |projectile|
            projectile.draw
        end
        @players.select do |player|
            player.draw
        end
         @level.as(Level).draw
    end

    def drawsprite(sprite)
        sprite.scale({1.001,1.001})
        @window.draw sprite
    end

    # getter method for @level because it is "nillable" so it has to be cast
    # as a level each time its used so this makes it a lot easier.
    def get_level
        level.as(Level)
    end

end
