#! /usr/bin/ruby

#load 'extened.rb'
require File.join(__FILE__, '../extened')
p File.join(__FILE__, '../extened')

p "my name is Ahou".vowels.join('-')

require 'net/http'

#Net::HTTP.get_print('qomo.linux-ren.org', '/')

#require "git"
catch(:finish) do
    10.times do |i|
        throw :finish if i == 5
        puts i
    end
end

f = File.open("hello", "r")
p f.class
