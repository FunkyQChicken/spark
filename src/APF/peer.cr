require "./game.cr"
require "socket"


class Peer < Game
    def initialize(@window)
        super
        @out_socks = [] of UDPSocket
        @in_sock   = UDPSocket.new
        @port = 0
        init_network()
        spawn join_swarm()
    end

    def init_network
        say "initializing connections..."
        bound = false
        x = 10000
        port = x
        100.times do
            sock = UDPSocket.new
            begin
                sock.bind "localhost", x
                if bound
                    sock.close
                else
                    @in_sock = sock
                    @port = x
                    bound = true
                end
            rescue
                sock.connect "localhost", x
                @out_socks << sock
            end
            x += 1
        end
        say "done. found "+@out_socks.size.to_s+" other peer(s)"
        say "alerting them..."
        @out_socks.each do |sock|
            say "sending..."
            sock << "joining<=>"+@port.to_s+"\n"
            say "done sending."
        end
        say "done alerting."
    end

    def join_swarm
        say "joining swarm."
        loop do
            message, sender = @in_sock.receive
            subject, body = message.split "<=>"
            process_packet(subject, body, sender)
        end
    end

    def process_packet(subject,body, sender)
        case subject
        when "joining"
            say "aware of new peer, adding..."
            sock = UDPSocket.new
            sock.connect "localhost", body.to_i
            @out_socks << sock
            say "done adding."
        end
    end

    def tick
        super
    end

    # for printing debug messages
    def say(x)
        puts "PEER: " + x
    end
end
