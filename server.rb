require 'socket'
require 'open3'
require 'json'

def logger(client)
  puts('Saving client info to log...')
  logfile = open('log.log', 'w')
  logfile.puts("Client logged in from #{client}")
  logfile.close
end

puts("Gettings settings.json file...")
file = open('settings.json')
puts("Reading JSON file...")
json_data = file.read
puts("Parsing JSON...")
data = JSON.parse(json_data)
file.close
puts("Done.")
puts("Starting Server...")
host = data['host']
port = data['port'].to_i
server = TCPServer.open(host, port)
puts("Server started on #{host}:#{port}")
loop do
  client = server.accept
  sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
  puts("New client from #{remote_ip}")
  logger(remote_ip)
  client.puts("You are logged in from from #{remote_ip}")
  while line = client.gets
    if line.chop == 'exit'
      client.close
      puts("Server terminated by client.")
      exit
    else
      begin
        if line.to_s['pwd'] then
          puts(Dir.pwd)
          client.puts(Dir.pwd)
        #needs fixed
        #elsif line.to_s['cd'] then
        #  newDir = line[3..line.length]
        #  Dir.chdir(newDir)
        else
          stdin, stout, status = Open3.capture3(line.chop)
          client.puts(stdin)
          puts(stdin)
        end
      rescue
        client.puts("command not found")
      end
    end
  end
  client.close
end
