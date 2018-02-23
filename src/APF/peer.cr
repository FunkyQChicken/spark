require "./game.cr"
require "socket"


class Peer < Game 
    def initialize(@window)
        super
        @connection = TCPSocket.new("localhost",2234)
        say "sending..."
        @connection << "peer\n"
        say "sent."
    end

    def tick
        @connection << @players
        @connection << "\n"
        super 
    end 

    # for printing debug messages
    def say(x)
        puts "PEER: " + x
    end 
end
