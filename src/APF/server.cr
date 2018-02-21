
class Server

    def initialize()
    end

    def tick
    end

    # returns the data designated by the symbol
    def request_data(data_name : Symbol)
    end

    # sends data out to other games
    def send_data
    end

    # receives and organizes data
    def receive_data
    end

    # takes the received packets and creates all
    # of the other entities from it
    def build_data
    end
end
