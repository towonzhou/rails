# -*- encoding: UTF-8 -*-
##############################################################
# File Name: redis.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月22日 星期二 09时46分47秒
##############################################################

require 'redis'
require 'eventmachine'

def redis_conn
  @redis ||= Redis.new
end

redis_conn.lpush "cache_list", "hello"
#puts redis_conn.keys

# EM.run {
#   count = 1;
#   EM.add_periodic_timer(1) {
#     #`curl "http://localhost:3000/hi"`
#   }
# }
