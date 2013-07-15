class Person
    def name
        @name
    end

    def name=(name)
        @name = name
    end
end

person = Person.new

p person.name = 'hello'
