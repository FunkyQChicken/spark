require "crsfml/window"
require "socket"

class Window
    def initialize
        say "intializing..."
        window = SF::RenderWindow.new(SF::VideoMode.new(800, 600), "CrSFML works!")
        say "window made."
        game = Game.new(window)
        say "game made."
        window.framerate_limit = 60
        say "done initializing."
        say "entering game loop."
        while window.open?
            #take game input
            while event = window.poll_event()
                case event
                when SF::Event::KeyEvent
                    game.key_input(event.code,event.is_a? SF::Event::KeyPressed)
                when SF::Event::Closed
                    window.close()
                when SF::Event::Resized
                    visible_area = SF.float_rect(0, 0, event.width, event.height)
                    window.view = SF::View.new(visible_area)
                end
            end
            # update the game
            game.tick
            # make the screen grey
            window.clear SF::Color.new(200,200,200)
            # draw the game
            game.draw
            # update the window
            window.display()
        end
    end

    def say(x)
        puts "START: " + x
    end
end
