#! /usr/bin/ruby

#class Package
#    attr_accessor :name
#    def initialize name
#    end
#
#    def version 
#        `rpm -q --queryformat=%{Version} #{name}`
#    end
#end

def hello
    puts "hello world"
end

#man = Man.new
#puts a
#puts (p man.male).class
#yum_version = `rpm -qi yum`
#yuminfo = {}
#puts yum_version[1]
#yum_version.split(/\n/).collect { |el| 
#    el.split(/:/)[0].gsub(/^\s*|\s$*/, '')
#}
#yuminfo[el[0].gsub(/^\s*|\s$*/, '')] = el[1].gsub(/^\s*|\s$*/, '')
yum_version = `rpm -q --queryformat=%{Version} yum`
yum_release = `rpm -q --queryformat=%{Release} yum`
if yum_version.to_f == 3.4 and 
    yum_version.split(/\./).last.to_i == 3
    if yum_release.to_f <= 4.1
       #`yum update yum`
        puts "must update yum"
    end
end
