require "./world.cr"

# the Game class is the world class with drawing methods implemented.
# this allows a 'World' to be viewed through a window
# it also takes key input so that players can be moved and such.
class Game < World
    property window  : SF::RenderWindow,
             players : Array(Player)

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

        # the entities that the window will adjust to follow
        @to_follow = [] of Entity

        # all the players on the map, key input is sent to them and
        # projectiles collide with them
        @players   = [] of Player

        # 'player one' in a sense
        player = Player.new self

        # add 'player one' to  the players array
        # and to follow so that it can be interacted with
        @players << player
        @to_follow << player
    end

    # move the window a little bit to put all the followed
    # entities towards the center
    def update_view()
        size = window.size
        scale =  @window_height / size[1].to_f
        new_width = size[0] * scale
        new_height = size[1] * scale

        # take the average of the followed entities.
        new_x = 0
        new_y = 0
        @to_follow.each do |ent|
            entity = ent.as(Entity)
            new_x += entity.x
            new_y += entity.y
        end
        new_x /= @to_follow.size
        new_y /= @to_follow.size

        # and then apply a portion of the average inversely porportional
        # with 'smooth' to adjust the window so that the window's center
        # is closer to the average of the followed entities lovations
        @x = ((@x * @smooth + new_x) / (@smooth + 1)).to_i
        @y = ((@y * @smooth + new_y) / (@smooth + 1)).to_i
        rect = SF.float_rect((@x - new_width / 2).to_i, (@y - new_height / 2).to_i , new_width.to_i, (new_height).to_i)
        view = SF::View.new
        view.reset rect
        @window.view = view
    end

    # draw the level, the players,  and the entities to the screen
    def draw()
        # but first update the view so that
        # the things we want to see are on screen
        update_view()
        @projectiles.each do |projectile|
            projectile.draw
        end
        @players.each do |player|
          player.draw
        end
        get_level.draw
    end

    # same as world tick but also updates players
    def tick
      @players.each do |player|
        player.tick
      end
      super
    end

    # all key input passed to Game is just passed
    # to everything in the player array.
    def key_input(key, down : Bool)
        @players.each do |player|
          player.input(key, down)
        end
    end

    # draw a given sprite to the screen,
    # initialy was neede for somthing else but workaround was found, so
    # IDEA: remove this method as it is semi-redundant and pointless.
    def drawsprite(sprite)
        @window.draw sprite
    end
end
