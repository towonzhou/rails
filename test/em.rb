# -*- encoding: UTF-8 -*-
##############################################################
# File Name: em.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月22日 星期二 16时16分45秒
##############################################################

#require 'rubygems'
#require 'eventmachine'
#require 'em-http'
#
#EM.run {
#  http = EM::HttpRequest.new("http://www.goole.com").get
#  http.callback { |h|
#    puts h.response_header
#    EM.stop
#  }
#  count = 1;
#  EM.add_periodic_timer(1) {
#    EM.stop if count == 5
#    puts "#{count}: hello world"
#    count += 1
#  }
#}
#

require 'rubygems'
require 'httparty'
require 'json'

res = HTTParty.get("http://www.google.com")
puts res.header

# => {"isReliable"=>true, "confidence"=>0.5834181, "language"=>"cy"}
