require "crsfml/window"

class Window
    def initialize
        window = SF::RenderWindow.new(SF::VideoMode.new(800, 600), "CrSFML works!")
        game = Game.new(window)
        window.framerate_limit = 60
        while window.open?
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
        game.tick
        window.clear SF::Color.new(200,200,200)
        game.draw
        # Nothing is drawn, so the window may be blank or even garbled
        window.display()
        end
    end
end
