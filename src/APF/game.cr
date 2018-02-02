
class Game 
    property window       : SF::RenderWindow
    property entities     : Array(Entity) 
    property projectiles  : Array(Entity)
    property players      : Array(Entity)
    property level        : Level

    def initialize(@window)
        @entities    = [] of Entity 
        @projectiles = [] of Entity
        @players     = [] of Entity
        @level       = Level.new  
        @window      = window
    end

    def key_input(key)
        @players.each do |player|
            player.input(key)
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


    def draw()
        @projectiles.each do |projectile|
            projectile.draw
        end
        @players.select do |player|
            player.draw    
        end
    end
end
