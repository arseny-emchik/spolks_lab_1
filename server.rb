#!/usr/bin/env ruby

require 'socket'
require 'colored'

class Server
  def initialize(port)
    @server = TCPServer.new port
    puts "Server is running on: ".red + "#{port}".green + " port.".red
  end

  def run
    loop do
      client_listener
    end
  end

  private

  def client_listener
    Thread.start(@server.accept) do |client, _|
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

server = Server.new(ARGV[0].nil? ? 2000 : ARGV[0].to_i)
server.run
