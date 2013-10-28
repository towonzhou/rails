# -*- encoding: UTF-8 -*-
##############################################################
# File Name: 1.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月23日 星期三 17时50分22秒
##############################################################

require 'rubygems'
require 'eventmachine'
require 'uri'
require 'net/http'

host = "toapi.himovie.com"
path = "/Ticket_API.asmx"
#head = "{"Content-Type"=>"text/xml; charset=utf-8", "SOAPAction"=>"http://tempuri.org/ReturnOrderState"}"

body = "<?xml version='1.0'?>\n      <env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\">\n      <env:Body>\n      <tns:ReturnOrderState xmlns:tns=\"http://tempuri.org/\">\n      <tns:apiCode>newair</tns:apiCode>\n      <tns:createOrderID>1819853</tns:createOrderID>\n      <tns:time>1382944486</tns:time>\n      <tns:cryptograph>d01195cbd081325bbd1c4c7cffabeb74</tns:cryptograph>\n      </tns:ReturnOrderState>\n      </env:Body>\n      </env:Envelope>"
#req = Net::HTTP::Post.new(path, initheader = {"Content-Type"=>"text/xml; charset=utf-8","SOAPAction"=>"http://tempuri.org/ReturnOrderState"})
req = Net::HTTP::Post.new(path, initheader = {"Content-Type"=>"text/xml; charset=utf-8"})
req.body = body
res = Net::HTTP.new(host).start { |http|
  http.request(req)
}
puts res.body
