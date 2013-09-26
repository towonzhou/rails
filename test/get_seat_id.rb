# -*- encoding: UTF-8 -*-
#########################################################################
# File Name: 5.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年09月05日 星期四 09时40分29秒
#########################################################################

#金逸get seat_id的
class Hash
  def to_param
    collect do |key, value|
      "#{key}=#{value}"
    end * '&'
  end
end

class A
  STAT = {DEFAULT: 0}
  def initialize
    @a = 99
  end
  def b arg
    if arg.to_s =~ /^stat_to_(.+)$/
      p "hello"
      STAT[$1.upcase.to_sym]
    end
  end
end

#p a.new.get_instance(:@a)
#p a.instance_eval { @a }

require 'net/http'
url = "http://localhost:8080/jy/seats?feature_app_no=44729596"
uri = URI(url)

require 'nokogiri'
require 'open-uri'
require 'json'
x = Net::HTTP.get(uri)
#doc = Nokogiri::HTML(x)
json = JSON.parse x
seats_info = []
seats = json["sections"]["01"]["seats"]
#which seats want lock
wswl = "2:3"
wswl.split("|").each do |w|
  seats.each do |e|
    if e["row_num"] == w.split(":").first && e["col_num"] == w.split(":").last
      seats_info << e
    end
  end
end
p seats_info
