#! /usr/bin/ruby

class String
    def letter
        self.gsub(/\s\w|^\w/) { |l| l.upcase }
    end
end

p "the is zhou".letter

#p "the is zhou".gsub(/\b\w/) { |l| l.upcase }
#raise ArgumentError, "fails" \

#require 'test/unit'
#
#class TestLetter < Test::Unit::TestCase
#    def test_case
#        assert_equal("This Is A Test", "this is a test".letter)
#    end
#end

require 'benchmark'

#p Benchmark.measure { 10000.times { p '.' } }

#File.open('extened.rb') do |f|
#    p f.gets
#    f.each { |l| puts l}
#end

File.open('test', 'r+') do |f| 
    #p @file.read
    f.seek(-2, IO::SEEK_END)
    p "end_of_file" if f.eof?
    p f.getc
    #File.open('hello', 'w') { |l| l.write('h') }
end
