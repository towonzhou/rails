# -*- encoding: UTF-8 -*-
##############################################################
# File Name: make_requests.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月08日 星期二 13时49分10秒
##############################################################

require File.join(File.expand_path('../', __FILE__), 'vcr_setup.rb')

VCR.use_cassette('em_http') do
  EventMachine.run do
    http_array = %w[ foo bar bazz ].map do |p|
      EventMachine::HttpRequest.new("http://localhost:8080/#{p}").get
    end

    http_array.each do |http|
      http.callback do
        puts http.response

        if http_array.all? { |h| h.response.to_s != '' }
          EventMachine.stop
        end
      end
    end
  end
end
