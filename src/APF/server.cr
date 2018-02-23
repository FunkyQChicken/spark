require "socket"
require "./world.cr"

class Server < World

    @peers : Array(TCPSocket)

    def initialize
        super 
        @peers = [] of TCPSocket
        @server = TCPServer.new("localhost",2234)
        open_server 
    end

    def tick
        super
        Fiber.yield
    end 
    # adds all peers to the mater list of them for 
    # processing
    def open_server
        spawn do
            loop do
                Fiber.yield
                peer = @server.accept
                say "peer detected"
                stat = peer.gets 
                say "peer status -> " + stat.to_s
                if stat == "peer"
                    spawn assimilate(peer)
                else
                    say "wasn't a peer"
                end 
            end
        end
    end

    def assimilate(peer)
        say "peer assimilated"
        loop do 
            info = peer.gets
            
            Fiber.yield 
        end 
        say "peer dropped"
    end

    def say(message)
        puts "SERV: " + message
    end

end
