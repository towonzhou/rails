# -*- encoding: UTF-8 -*-
##############################################################
# File Name: 1.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月11日 星期五 14时55分30秒
##############################################################

require 'digest/md5'
require 'eventmachine'
require 'em-http-request'
require 'fiber'
require 'json'

module Imqq
  class Request
    def debug data
      print "------"
      puts data.to_s
    end

    def initialize(p = {})
      # TODO => load config file
    end

    def method_missing(m, *args)
      user_name = "szcmbchina"
      key = "Aa123456"
      target = m

      #初始值
      query = {
        user: user_name
      }

      #把需要加密的参数转换成hash的形式,并加入到query中
      query = sign_hash = args.inject(query) do |r, e|
        r.merge(e)
      end

      #把参数的值组合在一起,算出md5后转化为大写
      query[:checkcode] = Digest::MD5.hexdigest(sign_hash.keys.inject("") do |r, e|
        r += sign_hash[e].to_s
      end + key).upcase

      query[:cmd] = target.to_s
      url = "http://119.147.52.153:7000/webapi/call.action"
      require 'active_support'
      require 'active_support/cache/dalli_store'
      #`google-chrome "#{url}?#{query.to_param}"`

      debug query
      http_response = nil
      EM.run do
        Fiber.new {
          http_response = async_fetch(url, :body => query).response
          EM.stop
        }.resume
      end
      debug http_response
      #保存结果
      #file = File.expand_path('../',__FILE__) + "/a"
      #File.open(file,"w") do |f|
      #  f.write http_response
      #end
      #`google-chrome "#{file}"`
      #json = JSON.parse http_response
      #p json["Data"]
    end

    def async_fetch(url, params = {})
      f = Fiber.current
      connect_options = {
      }
      req_options = {
        :body => params[:body] || {}
      }

      http = EM::HttpRequest.new(url, connect_options).post(req_options)
      http.errback { f.resume }
      http.callback { f.resume }

      Fiber.yield
      p [:HTTP_ERROR, http.error] if http.error
      http
    end
  end
end

sig = Time.now.utc.strftime("%Y%m%d%H%M%S%4N") #流水号,当前utc时间,精确到秒后四位小数
mobile = "13360090178"
city_id = "440300"
film_name = "金刚狼2"

def h m, r
  Hash[m,r]
end

=begin
场次示例
<show>
<showid>1212302</showid>
<cinemaid>620</cinemaid>
<cinemaname>百老汇影城深圳COCO PARK购物公园店</cinemaname>
<cityid>440300</cityid>
<countyid>440307</countyid>
<hallid>2980</hallid>
<hallname>1号厅</hallname>
<filmformat>1</filmformat>
<filmname>金刚狼2</filmname>
<showdate>2013-10-17</showdate>
<showtime>2225</showtime>
<standprice>120</standprice>
<memberprice>72</memberprice>
<normalprice>72</normalprice>
<url>aHR0cDovLzExOS4xNDcuNTIuMTUzOjcwMDAvd2ViL2Nob29zZVNlYXQuYWN0aW9uP3NpPTEyMTA1ODEmdG09NCZjaz1DRTc2MzI2RDE1RDcyNTAyRkM=</url>
</show>
=end
#Imqq::Request.new.qryCityList
#影片列表
#Imqq::Request.new.qryFilmListByCity h(:cityid, city_id)
#场次列表
#Imqq::Request.new.qryShowList h(:cityid, city_id), h(:filmname, film_name)
#座位图
#showid = "1212302"
#Imqq::Request.new.qrySeat h(:showid, showid)
#锁座
#seatid = "239362"
#Imqq::Request.new.lockSeat h(:userphone, mobile), h(:showid, showid), h(:seats,seatid)
