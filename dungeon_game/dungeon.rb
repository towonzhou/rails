class Dungeon
    attr_accessor :player, :rooms
    def initialize(player_name)
        @player = Player.new(player_name)
        @rooms = []
    end

    class Player
        attr_accessor :name, :location
        def initialize(player_name)
            @name = player_name
        end
    end

    class Room
        attr_accessor :name
        def initialize(name)
            @name = name
        end
    end
end

class Dungeon
    def add_room(name)
        @rooms << Room.new(name)
    end
end

dungeon = Dungeon.new('zhou')
dungeon.add_room('hong')
p dungeon.rooms.first.name
