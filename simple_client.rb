#!/usr/bin/ruby

require 'socket'

hostname = 'localhost'
port = 2000

s = TCPSocket.open(hostname, port)

while line = s.gets		# cчитывает строки из серверного сокета
	puts line.chop		# выводит их на экран
end

s.close					# закрывает соединение