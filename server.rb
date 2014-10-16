#!/usr/bin/env ruby

require 'socket'
require 'colored'

module Connection
  class SocketTCP < Socket
    def initialize(port, addr)
      super(Socket::AF_INET, Socket::SOCK_STREAM, 0)
      setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
      @sockaddr = Socket.sockaddr_in(port, addr)
    end

    def sock_bind(queue = 10)
      bind(@sockaddr)
      listen(queue)
    end
  end
end



class Server
  ADDR = '192.168.43.195'.freeze

  def initialize(port)
    # @server = TCPServer.new port
    @server = Connection::SocketTCP.new(port, ADDR)
    @server.sock_bind
    puts "Server is running on: ".red + "#{port}".green + " port.".red
  end

  def run
    loop do
      client_listener
    end
  end

  private

  def client_listener
    Thread.start(@server.accept) do |client, client_info|
      p client_info
      loop do
        data_str = client.gets.chomp

        if data_str == "exit"
          client.puts "Stop client. Bye!".blue
          client.close and return
        end

        client.puts data_str
      end
    end
  end
end

server = Server.new(ARGV[0].nil? ? 2004 : ARGV[0].to_i)
server.run
