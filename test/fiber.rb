# -*- encoding: UTF-8 -*-
##############################################################
# File Name: fiber.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年09月27日 星期五 22时40分28秒
##############################################################

require 'fiber'

#a = 1
#f1 = Fiber.new do |a|
#end
#
#f2 = Fiber.new do
#  p "hi"
#end
#
#
#f = Fiber.new do |a|
#  c = Fiber.yield a+100
#  p c
#end
#
#p f.resume(10)
#f.resume(100)

f1 = Fiber.new {
  sleep 2
  p "fiber 1"
}

f1.resume
p "fiber 2"
