require "./game.cr"
require "socket"


class Peer < Game
    def initialize(@window)
        super
        @out_socks = [] of UDPSocket
        @in_sock   = UDPSocket.new
        @port = 0
        @local_players = [] of Player
        # make local players so that key input can go only to them
        @local_players += @players
        # make other players accessable by the ip that instatiated them
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
        send "joining<=>"+@port.to_s+"\n"
        send get_player_string
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
        @local_players.each do |player|
            player.input(key, down)
        end
        str = "in<=>"+key.to_s+","+ (down ? "1" : "0")
        send str
    end

    def tick
      super
      @local_players.each_with_index do |player,i|
          send "up<=>" + i.to_s + "," + player.x.to_s  + "," + player.y.to_s + ","
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
        #input
        when "in"
            code, d = body.split(",")
            player  = @other_players[sender]
            down    = d[0].to_i == 1
            player.input(code, down)
        # update position
        when "up"
            ind, x, y = body.split(",")
            player = @other_players[sender]
            player.x = x.to_f
            player.y = y.to_f
        when "player"
            say "adding player..."
            player = Player.from_string(body, self)
            @players << player
            @other_players[sender] = player
        end
    end

    # sends a string to all the out_socks,
    # if the sending fails it drops the sock from the list
    # the string is received by the process_packet
    # method
    def send(str)
        @out_socks = @out_socks.select do |sock|
            error = false
            begin
              sock << str
            rescue
              error = true
            end
            !error
        end
    end

    def get_player_string
        player = @local_players[0]
        "player<=>" + player.get_string
    end

    # for printing debug messages
    def say(x)
        puts "PEER: " + x
    end
end
