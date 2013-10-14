# -*- encoding: UTF-8 -*-
##############################################################
# File Name: em.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月08日 星期二 09时27分12秒
##############################################################

#eventmachine test
#EM是一个基于事件驱动的高性能I/O框架,基于Reactor模式.(Reactor v.s Proactor, 事件驱动 v.s 线程模型)

require 'rubygems'
require 'eventmachine'
require 'em-http-request'
require 'fiber'

def async_fetch url
  f = Fiber.current
  options = {
    :path => "/hi_movie/seats",
    :query => "play_plan_id=943328&hall_id=179"
  }
  http = EM::HttpRequest.new('http://localhost:8080').get options
  http.callback { f.resume(http) }
  http.errback { f.resume(http) }

  Fiber.yield

  if http.error
    p [:HTTP_ERROR, http.error]
  end

  http
end

EM.run do
  Fiber.new {
    puts "Setting up HTTP request #1"
    data = async_fetch('http://0.0.0.0/')
    puts "Fetched page #1: #{data.response_header.status}"

    puts "Setting up HTTP request #2"
    data = async_fetch('http://www.yahoo.com/')
    puts "Fetched page #2: #{data.response_header.status}"

    puts "Setting up HTTP request #3"
    data = async_fetch('http://non-existing.domain/')
    puts "Fetched page #3: #{data.response_header.status}"


    (1..20).each do |i|
      puts "Setting up HTTP request #{i}"
      data = async_fetch('http://non-existing.domain/')
      puts "Fetched page #{i}: #{data.response_header.status}"
    end

    EventMachine.stop
  }.resume
end

puts "done"
