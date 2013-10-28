# -*- encoding: UTF-8 -*-
##############################################################
# File Name: https-post.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月28日 星期一 23时29分16秒
##############################################################

uri = URI.parse("https://auth.api.rackspacecloud.com")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new("/v1.1/auth")
request.add_field('Content-Type', 'application/json')
request.body = {'credentials' => {'username' => 'username', 'key' => 'key'}}
response = http.request(request)
