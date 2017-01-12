#!/usr/bin/ruby

require 'socket'
require 'json'

puts "Тип запроса ( 'g' - GET, 'p' - POST )"
case gets.chomp
	when "g" then request_type = "GET"
	when "p" then request_type = "POST"
end
puts "Путь к файлу"

path = "/#{gets.chomp}"                 # The file we want 
host = 'localhost'     					# The web server
port = 2000                             # Default HTTP port

# This is the HTTP request we send to fetch a file
request = "#{request_type} #{path} HTTP/1.0"
headers = {"Content-Length" => 0, "From" => "first@mail.com"}
body = {}
request
if request_type == "POST"
	body = {:viking => {}}
	puts "Введите имя викинга!"
	body[:viking][:name] = gets.chomp
	puts "Введите email викинга!"
	body[:viking][:email] = gets.chomp
	headers["Content-Length"] += body.to_json.length
end
request += "\r\n" if headers
request += headers.to_json
request += "\r\n\r\n"
request += body.to_json if headers["Content-Length"] > 0
puts request
socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2) 
puts headers 
puts "\n"
puts body                      # And display it