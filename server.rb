require 'socket'
require 'open3'

hostname = 'localhost'
port = 2000

s = TCPServer.open(hostname, port)

loop do
  client = s.accept
  while line = client.gets   # Read lines from the socket
    if line.chop == 'exit'
      client.close
      exit
    else
      begin
        stdin, stout, status = Open3.capture3(line.chop)      # And print with platform line terminator
        client.puts(stdin)
        puts(stdin)
      rescue
        client.puts("command not found")
      end
    end
  end
  client.close


end
