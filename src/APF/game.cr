
class Game < World
    property window : SF::RenderWindow,

    def initialize(@window)
        super()
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
        # the wordl
        # player one
        play = Player.new self
        @players << play
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
end
