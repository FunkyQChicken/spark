require "crsfml/window"
require "socket"

class Window
    def initialize
        say "intializing..."
        window = SF::RenderWindow.new(SF::VideoMode.new(800, 600), "Spark")
        # maximum framerate to prevent game from eating up cpu
        window.framerate_limit = 60
        say "window made."
        # this is the game (Peer < Game < World) and takes ticks and draw n' stuff.
        game = Peer.new(window)
        say "game made."
        say "done initializing."
        say "entering game loop."
        while window.open?
            #take game input
            while event = window.poll_event()
                case event
                # every keypress gets sent to the game.
                when SF::Event::KeyEvent
                    game.key_input(event.code.to_s,event.is_a? SF::Event::KeyPressed)
                # close the window when closed
                when SF::Event::Closed
                    window.close()
                # allows window resizing
                when SF::Event::Resized
                    visible_area = SF.float_rect(0, 0, event.width, event.height)
                    window.view = SF::View.new(visible_area)
                end
            end
            # allow other fibers a chance to process.
            # namely the join_swarm method in peer.
            Fiber.yield
            # update the game
            game.tick
            # make the screen grey/gray/gerae as default color
            window.clear SF::Color.new(200,200,200)
            # draw the game
            game.draw
            # update the window
            window.display()
        end
    end

    # for a debug log of sorts. allows easy identification of where the
    # error came from.
    def say(x)
        puts "START: " + x
    end
end
