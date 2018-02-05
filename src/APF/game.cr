
class Game 
    property window       : SF::RenderWindow,
             projectiles  : Array(Entity),
             players      : Array(Player),
             level        : Level | Nil  

    def initialize(@window)
        @projectiles = [] of Entity
        @players     = [] of Player
        @level       = Level.new self
        @window      = window
        @projectiles << Entity.new self
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
        @level.as(Level).draw
    end

    def drawsprite(sprite) 
        @window.draw sprite
    end
end
