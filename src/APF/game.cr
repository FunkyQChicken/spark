
class Game
    property window       : SF::RenderWindow,
             projectiles  : Array(Entity),
             players      : Array(Player),
             level        : Level | Nil,
             clock        : SF::Clock

    def initialize(@window)

        # the height that the window should show,
        # not its actual height, it is its relative height
        # to the world
        @window_height = 900
        # the location of the center of the window 
        @x = 0
        @y = 0
        # the smoothness of the window movement
        # higher is smoother
        @smooth = 20

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

    def update_view()
        size = window.size
        scale = @window_height / size[1] 
        new_width = size[0] * scale
        new_height = size[1] * scale
        new_x = 0
        new_y = 0 
        @players.each do |player|
            new_x += player.x
            new_y += player.y
        end
        new_x /= players.size
        new_y /= players.size
        @x = ((@x * @smooth + new_x) / (@smooth + 1)).to_i
        @y = ((@y * @smooth + new_y) / (@smooth + 1)).to_i
        rect = SF.float_rect((@x - new_width / 2).to_i, (@y - new_height / 2).to_i , new_width.to_i, (new_height).to_i)
        view = SF::View.new
        view.reset rect 
        @window.view = view
    end

    def draw()
        update_view()
        @projectiles.each do |projectile|
            projectile.draw
        end
        @players.select do |player|
            player.draw
        end
        get_level.draw
    end

    def drawsprite(sprite)
        @window.draw sprite
    end

    # getter method for @level because it is "nillable" so it has to be cast
    # as a level each time its used so this makes it a lot easier.
    def get_level
        level.as(Level)
    end

end
