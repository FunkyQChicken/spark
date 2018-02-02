require "crsfml/window"

class Window
    def initialize
        window = SF::RenderWindow.new(SF::VideoMode.new(800, 600), "CrSFML works!")
        game = Game.new(window)
        while window.open?
          while event = window.poll_event()
            if event.is_a? SF::Event::Closed
              window.close()
            end
            game.key_input(event)
          end
          game.tick
          game.draw
          # Nothing is drawn, so the window may be blank or even garbled
          window.display()
        end
    end
end
