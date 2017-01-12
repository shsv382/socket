#!/usr/bin/ruby

require 'socket'
require 'json'

server = TCPServer.open(2000)	
loop {
	client = server.accept
	request = client.gets

	puts request
	params = {}
	params = JSON.parse(client.gets)
	client.read(2)
	body = JSON.parse(client.read(params["Content-Length"])) if params["Content-Length"] > 0

#	headers += client.gets.to_hash until NoMethodError

#	header, body = request.split("\r\n\r\n", 2)
#	head, headers = header.split("\r\n", 2)

	type, path, version = request.split(" ", 3)
	version = version.strip

	params.each do |key, value|
		puts key.to_s + ": " + value.to_s
	end

	puts body.inspect if body

	if File.exists?(path[1..-1])
		response_code = "200 OK"
	else
		response_code = "404 Not Found"
	end
	case type
	when "GET"
		f = File.open(path[1..-1]) if response_code == "200 OK"
		client.print version
		client.print " "
		client.print response_code 
		client.print "\r\n\r\n"
		if f
			client.puts f.readlines
			f.close
		end
#		client.puts "Closing connection!"
	when "POST"
		f = File.readlines("thanks.html")
		string = ""
		if body
			body.each do |key, value|
				value.each do |key1, value1|
					string << "		<li>#{key1}: #{value1}</li>\n"
				end
			end
		end

		nw = []
		f = f.each do |n|
			if n.include?("yield")
				n = string
			end
			nw << n
		end
		puts nw
		client.puts nw
	end
	client.close
}