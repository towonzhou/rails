# -*- encoding: UTF-8 -*-
##############################################################
# File Name: skiplist.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年10月28日 星期一 23时57分52秒
##############################################################

class Node
  attr_accessor :key
  attr_accessor :value
  attr_accessor :forward

  def initialize(k, v = nil)
    @key = k
    @value = v.nil? ? k : v
    @forward = []
  end
end

class SkipList
  attr_accessor :level
  attr_accessor :header

  def initialize
   @header = Node.new(1)
   @level = 0
   @max_level = 3
   @p = 0.5
   @node_nil = Node.new(1000000)
   @header.forward[0] = @node_nil
  end

  def search(search_key)
    x = @header
    @level.downto(0) do |i|
      while x.forward[i].key < search_key do
        x = x.forward[i]
      end
    end
    x = x.forward[0]
    if x.key == search_key
      return x.value
    else
      return nil
    end
  end

  def random_level
    v = 0
    while rand < @p && v < @max_level
      v += 1
    end
    v
  end

  def insert(search_key, new_value = nil)
    new_value = search_key if new_value.nil?
    update = []
    x = @header
    @level.downto(0) do |i|
      while x.forward[i].key < search_key do
        x = x.forward[i]
      end
      update[i] = x
    end
    x = x.forward[0]
    if x.key == search_key
      x.value = new_value
    else
      v = random_level
      if v > @level
        (@level + 1).upto(v) do |i|
          update[i] = @header
          @header.forward[i] = @node_nil
        end
        @level = v
      end
      x = Node.new(search_key, new_value)
      0.upto(v) do |i|
        x.forward[i] = update[i].forward[i]
        update[i].forward[i] = x
      end
    end
  end
end

#desk = 60
#
#def find src
#  s4 = [0, 80]
#  s3 = [0, 40, 80]
#  s2 = [0, 20, 40, 60, 80]
#  s1 = [0, 10, 20, 30, 40 , 50 , 60, 70, 80]
#
#  k = 4
#  index = 0
#
#  k.downto(1).each do |s|
#    i = index
#    a = eval("s#{s}")
#    p a
#    a[i..a.size].each_with_index do |e, i|
#      break index = i - 1 if e > src
#      puts "#{k} #{i} #{e}"
#      #"
#      #p "the result in s#{s}[#{index}]" if e == src
#    end
#
#    #eval("s#{s}").each_with_index do |e, i|
#    #  next index = i-1 if e > desk
#    #  p "the result in s#{s}[#{index}]"if e = desk
#    #end
#  end
#  p "the result in s#{s}[#{index}]" if e = desk
#
#end
#
#find 60

#class Note
#  attr_accessor :val, :nt, :down
#  def initialize val,nt,down
#    @val  = val
#    @nt   = nt #next
#    @down = down
#  end
#end
#
#s = [  [-1, 0, 0, 0, 0, 0, 0, 0,80] \
#      ,[-1, 0, 0, 0,40, 0, 0, 0,80] \
#      ,[-1, 0,20, 0,40, 0,60, 0,80] \
#      ,[-1,10,20,30,40,50,60,70,80] ]
#
#s1 = s2 = s3 = s4 = []
#s[3].each_with_index do |e,i|
#  eval("s4 << Note.new(#{e}, #{i+1}, nil)")
#end
#
#s[2].each_with_index do |e,i|
#  eval("s3 << Note.new(#{e}, #{i+1}, 4)") if e != 0
#end
#
#p s4
##s1 = s2 = s3 = s4 = []
##s1 << Note.new 0, 8, 2
##
##s1 << Note.new 0, nil, 2
##s2 << Note.new 0, 8, 2
