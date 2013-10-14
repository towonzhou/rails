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
require 'json'
require 'active_support'
require 'active_support/cache/dalli_store'

def seat_ids
  source = "HiMovie"
  play_plan_id = "943328"
  hall_id = "179"

  url = "http://localhost:8080"

  if source == "HiMovie"
    query = "play_plan_id=#{play_plan_id}&hall_id=#{hall_id}"
  else source == "Jy"
    query = "feature_app_no=#{feature_app_no}"
  end

  req_options = {
    :path => "/#{source.underscore}/seats",
    :query => query
  }

  http_response = nil
  EM.run do
    Fiber.new {
      http_response = async_fetch(url, req_options).response
      EM.stop
    }.resume
  end

  wswl = "3:1"

  json = JSON.parse http_response
  seat_ids = []
  seats = json["sections"]["01"]["seats"]
  wswl.split("|").each do |w|
    seats.each do |e|
      if e["row_num"] == w.split(":").first && e["col_num"] == w.split(":").last
        seat_ids << e["seat_id"]
      end
    end
  end
  p seat_ids
end

def async_fetch url, req_options
  f = Fiber.current
  http = EM::HttpRequest.new(url).get req_options

  http.callback { f.resume }
  http.errback { f.resume }

  Fiber.yield

  if http.error
    p [:HTTP_ERROR, http.error]
  end

  http
end

seat_ids

#EM.run do
#  Fiber.new {
#    puts "Setting up HTTP request #1"
#    data = async_fetch('http://0.0.0.0/')
#
#    #wswl = "3:2"
#
#    #json = JSON.parse data.response
#    #seat_ids = []
#    #seats = json["sections"]["01"]["seats"]
#    #wswl.split("|").each do |w|
#    #  seats.each do |e|
#    #    if e["row_num"] == w.split(":").first && e["col_num"] == w.split(":").last
#    #      seat_ids << e["seat_id"]
#    #    end
#    #  end
#    #end
#    #p seat_ids
#
#    EventMachine.stop
#  }.resume
#end
