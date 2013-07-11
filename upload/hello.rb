class Bird
  attr_reader :name
  def initialize name
    @name = name
  end

  def self.fly
    puts "i can fly"
  end

  def say
    puts "i am #{name}"
  end

  def change_name 
    name = "fuck"
    puts "i am #{name}"
  end
end

bird = Bird.new("didi")
#bird.name = "jack"
puts bird.name
#Bird.fly
bird.say
bird.change_name

puts Math::PI

module Eat
  def eat
    p "i can eat"
  end
end

module Sleep
  def sleep
    p "i can sleep"
  end
end

class Pig
  include Eat
  include Sleep
end

Pig.new.eat
Pig.new.sleep

module Item
  #extend self
  def self.name
    p "i'm item class"
  end
end

Item.name
