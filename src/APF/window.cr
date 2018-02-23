require "crsfml/window"
require "socket"

class Window
    def initialize
        serv = nil 
        say "checking for server..."
        begin
            TCPSocket.new("localhost",2234) << "no, not a  peer"
            say "server found."
        rescue 
            say "no server found, creating server..."
            serv = Server.new
            say "server created."
        end
    
        window = SF::RenderWindow.new(SF::VideoMode.new(800, 600), "CrSFML works!")
        game = Peer.new(window)
        window.framerate_limit = 60
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
            Fiber.yield
            # update the game
            game.tick
            # if your the server owner, tick
            serv.tick() if (!serv.nil?)
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
