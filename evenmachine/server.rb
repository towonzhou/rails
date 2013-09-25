# -*- encoding: UTF-8 -*-
##############################################################
# File Name: server.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年09月26日 星期四 01时03分27秒
##############################################################

require 'rubygems'
require 'eventmachine'

module Server
  def receive_data(data)
    puts data
    send_data("hello\n")
  end
end

EM.run do
  EM.start_server 'localhost', 8080, Server
end
