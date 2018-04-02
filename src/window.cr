require "crsfml/window"
require "socket"
require "./spark/*"

class Window
    def initialize
        say "intializing..."
        window = SF::RenderWindow.new(SF::VideoMode.new(800, 600), "Spark")
        # maximum framerate to prevent gui from eating up cpu
        window.framerate_limit = 60
        say "window made."
        # this is the gui (Peer < Game < World) and takes ticks and draw n' stuff.
        gui : GUI = Selector_GUI.new(window)
        say "gui made."
        say "done initializing."
        say "entering gui loop."
        while window.open?
            #take gui input
            while event = window.poll_event()
                case event
                # every keypress gets sent to the gui.
                when SF::Event::KeyEvent
                    gui.key_input(event.code.to_s,event.is_a? SF::Event::KeyPressed)
                when SF::Event::MouseButtonPressed
                    gui.mouse_click(event.x, event.y)
                when SF::Event::MouseButtonReleased
                    gui.mouse_release
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
            # update the gui
            gui =  gui.tick
            # make the screen grey/gray/gerae as default color
            window.clear SF::Color.new(200,200,200)
            # draw the gui
            gui.draw
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
