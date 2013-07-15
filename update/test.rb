#! /usr/bin/env ruby

x = {'a' => 'b', 'c' => 'd'}
p x['a']

a = lambda { |x| p x }
a.call(2)

p Time.now
p Time.now - 10

b = 2

class Person
    attr_accessor :z
    def initialize(x)
        @z = x
    end

    def put_z
        set_z 10
    end

    protected
    def set_z z
        @z = z
    end
end

class Doctor < Person
    def name
        "Dr." + super
    end
end

person = Person.new(5)
p person.z
p person.put_z
p person.z
