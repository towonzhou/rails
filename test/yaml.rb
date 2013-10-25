# -*- encoding: UTF-8 -*-
##############################################################
# File Name: yaml.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月21日 星期一 14时27分10秒
##############################################################

require 'yaml'
file = File.expand_path('../yaml.yml', __FILE__)
config = YAML.load(File.open(file))
p config["notice_det"]
