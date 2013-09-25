# -*- encoding: UTF-8 -*-
##############################################################
# File Name: even.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年09月26日 星期四 00时38分37秒
##############################################################

require 'rubygems'
require 'eventmachine'

EventMachine.run do
  EM.add_periodic_timer(1) { puts "periodic hello" }

  EM.add_timer(4) do
    puts "in timer 3 seconds"
    EM.stop_event_loop
  end
end

puts "All Done"
