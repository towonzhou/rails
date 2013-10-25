# -*- encoding: UTF-8 -*-
##############################################################
# File Name: timeout.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月17日 星期四 09时51分19秒
##############################################################

##试用timeout

require 'timeout'
require 'fiber'
require 'net/http'

puts Time.now
(1..5).each do |i|
  Fiber.new do
    p Fiber.current
    url = URI.parse("http://www.google.com")
    Net::HTTP.get(url)
    puts "#{i}=============================="
  end.resume
end
puts Time.now
