# -*- encoding: UTF-8 -*-
##############################################################
# File Name: vcr_setup.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月08日 星期二 13时46分54秒
##############################################################

require 'em-http-request'

start_sinatra_app(:port => 7777) do
  %w[ foo bar bazz ].each_with_index do |path, index|
    get "/#{path}" do
      sleep index * 0.1 # ensure the async callbacks are invoked in order
      ARGV[0] + ' ' + path
    end
  end
end

require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'cassettes'
end
