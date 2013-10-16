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

module Wpw
  class Request
    def debug data
      print "------"
      puts data.to_s
    end

    def initialize(p = {})
      # TODO => load config file
    end

    def method_missing(m, *args)
      user_name = "WP_XKQUserAPI"
      key = "MtmjRWdmc4GQ3rzR"
      target = m

      #初始值
      query = {
        UserName: user_name,
        Target: target.to_s
      }

      #把需要加密的参数转换成hash的形式
      query = sign_hash = args.inject(query) do |r, e|
        r.merge(e)
      end

      #把参数按照key的升序排列后,将值组合在一起
      query[:Sign] = Digest::MD5.hexdigest(sign_hash.keys.sort.inject("") do |r, e|
        r += sign_hash[e].to_s
      end + key)

      debug query
      http_response = nil
      EM.run do
        url = "http://test.api.wangpiao.com"
        if target.to_s == "Sell_LockSeatPage"
          url = "http://test.api.wangpiao.com/lockseat/b/default.aspx"
          query[:Sign] = Digest::MD5.hexdigest(user_name + target.to_s + key)
          require 'active_support'
          require 'active_support/cache/dalli_store'
          `google-chrome "#{url}?#{query.to_param}"`
          return
        end

        Fiber.new {
          http_response = async_fetch(url, :body => query).response
          EM.stop
        }.resume
      end
      debug http_response
      json = JSON.parse http_response
      p json["Data"]
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
mobile = "18620414923"

def h m, r
  Hash[m,r]
end

seqno = "5192908"
Wpw::Request.new.Sell_LockSeatPage h(:SeqNo, seqno), h(:LockFlag, sig)
#Wpw::Request.new.Sell_ApplyTicket h(:SID,serial_num), h(:PayType,9998), h(:Mobile, mobile), h(:MsgType,2), h(:Amount, 30.00), h(:UserAmount, 40.00), h(:GoodsType,1)


