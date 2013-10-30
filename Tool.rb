BLOCK_POINT = 50
BOMB_POINT = 50
ROBOT_POINT = 30
MIN_TOOL_POINT = ROBOT_POINT
MAX_TOOL_NUM = 10

class Tool
    attr_accessor :id,:name,:flag,:cost
    def initialize(id,name,flag,cost)
        @id = id
        @name = name
        @flag = flag
        @cost = cost
    end
end

class Block < Tool
end
class Bomb < Tool
end
class Robot < Tool
end
