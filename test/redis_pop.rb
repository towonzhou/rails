# -*- encoding: UTF-8 -*-
##############################################################
# File Name: redis_pop.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月22日 星期二 16时03分16秒
##############################################################
require 'redis'

redis = Redis.new
p redis.lrange("task_list",0,-1)
