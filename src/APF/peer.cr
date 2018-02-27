require "./game.cr"
require "socket"


class Peer < Game
    def initialize(@window)
        super
        @out_socks = [] of UDPSocket
        @in_sock   = UDPSocket.new
        @port = 0
        @other_players = {} of Socket::IPAddress => Player
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
            sock << get_player_string
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

    def key_input(key, down)
        super
        str = "input<=>"+key.to_s+","+ (down ? "1" : "0")
        @out_socks.each do |sock|
            sock << str
        end
    end

    def process_packet(subject, body, sender)
        case subject
        when "joining"
            say "aware of new peer, adding..."
            sock = UDPSocket.new
            sock.connect "localhost", body.to_i
            @out_socks << sock
            sock << get_player_string
            say "done adding."
        when "input"
            say "INPUT: " + body
            code, d = body.split(",")
            player  = @other_players[sender]
            down    = d[0].to_i == 1
            player.input(code, down)
        when "player"
            say "adding player..."
            player = Player.new(self)
            @projectiles << player
            @other_players[sender] = player
        end
    end



    def get_player_string
        "player<=>new"
    end
    # for printing debug messages
    def say(x)
        puts "PEER: " + x
    end
end
