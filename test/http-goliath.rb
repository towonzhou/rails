# -*- encoding: UTF-8 -*-
##############################################################
# File Name: http-goliath.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月26日 星期六 13时56分10秒
##############################################################

require 'goliath'
require 'em-synchrony/em-http'
require 'redis'
require 'net/http'

###在goliath中心跳发送http请求
module Goliath
  class Plugin
      def initialize(address, port, config, status, logger)
        @port = port
        @status = status
        @config = config
        @logger = logger

        @status[:ganglia] = Hash.new(0)
      end

      def run
        count = 0
        EM.add_periodic_timer(0.01) do
          p count += 1
          data = get_req('http://weidewang.com/')
          puts data.header
        end
      end

      def get_req url
        uri = URI(url)
        Net::HTTP.get_response(uri)
      end

  end
end

class HimovieDaemon < Goliath::API
  plugin Goliath::Plugin

  def response(env)
    [200, {}, "hi"]
  end
end
