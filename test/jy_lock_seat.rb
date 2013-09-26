# -*- encoding: UTF-8 -*-
##############################################################
# File Name: 6.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年09月24日 星期二 16时18分56秒
##############################################################

#金逸的锁座

require 'net/http'
require 'digest/md5'
url = "http://partner.okticket.cn:8012/TicketAPI.asmx/RealCheckSeatState"
#query = {
#  pAppCode: "",
#  pVerifyInfo: ""
#}

api_code = ""
api_key = ""
seat_info_size = 1

feature_app_no = "44667364"
serial_num = Time.now.utc.strftime("%Y%m%d%H%M%S") 
seat_no = "06010407"
ticket_price = 30
pay_type = "1"
recv_mobile_phone = "18620414923"
verify_info = 1
a = "#{api_code}#{feature_app_no}#{serial_num}#{seat_info_size}#{pay_type}#{recv_mobile_phone}#{api_key}".downcase

verify_info = Digest::MD5.hexdigest(a)[8,16]

pXmlString = %Q~<?xml version='1.0'?>
      <RealCheckSeatStateParameter>
      <AppCode>bjxkq</AppCode>
      <FeatureAppNo>#{feature_app_no}</FeatureAppNo>
      <SerialNum>#{serial_num}</SerialNum>
      <SeatInfos>
        <SeatInfo>
        <SeatNo>#{seat_no}</SeatNo>
        <TicketPrice>#{ticket_price}</TicketPrice>
        </SeatInfo>
      </SeatInfos>
      <PayType>#{pay_type}</PayType>
      <RecvMobilePhone>#{recv_mobile_phone}</RecvMobilePhone>
      <VerifyInfo>#{verify_info}</VerifyInfo>
      </RealCheckSeatStateParameter>~

p pXmlString

query = {
  pXmlString: pXmlString
}

uri = URI(url)

#require 'nokogiri'
#require 'open-uri'
#x = Net::HTTP.post_form(uri, query)
#p x
#doc = Nokogiri.HTML(x.body)
#p doc.children.children

#get_token_uri = URI "http://partner.okticket.cn:8012/TicketAPI.asmx/GetCinema"
#
#sign = []
#sign << api_code
#sign << api_key
#sign = Digest::MD5.hexdigest(sign.join.downcase)[8,16]
#
#get_token_query = {
#  pAppCode: "bjxkq",
#  pVerifyInfo: sign
#  }
#p get_token_query
#get_token_res = Net::HTTP.post_form(get_token_uri, get_token_query)
#doc = Nokogiri.HTML get_token_res.body
#p doc.children.children
