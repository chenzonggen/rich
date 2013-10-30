require "Tool"

class Player
    attr_accessor :id,:name,:money,:pos,:flag,:point,:luckyDays,:tools
    @@playerNames = {1=>"qianfuren", 2=>"atubo",3=>"jinbeibei",4=>"sunxiaomei"} 
    @@playerFlag = {1=>"Q", 2=>"A",3=>"S",4=>"J"}
    @@playerLandType = {1=>"159d", 2=>"26ae",3=>"37bf",4=>"48cg"}
    
    def initialize(id,name,flag,money)
        @id = id
        @name = name
        @flag = flag
        @money = money
        @pos = 0
        @point = 0
        @luckyDays = 0
        @tools = Array.new
    end
    
    def Player.playerNames
        @@playerNames
    end
    def Player.playerFlag
        @@playerFlag
    end
    def  Player.playerLandType
        @@playerLandType
    end
    
    def isLost?
        self.money < 0
    end
    
    def arrideAtPlace
        place = Map.map[self.pos]
        
        if place.owner == self and place.level < MAX_LEVEL
            upgradeLand(place)
        elsif place.owner != nil and place.owner !=                                                                                       self
            payFee(place)
            checkLost
        end
        
        case place.type
            when "0": buyLand(place)
            when "$": addPoint(place)
            when "T": buyTools
            when "G": getGift
        end
    end
    
    def toolNum(toolId)
        count = 0
        for tool in tools
            if tool.id == toolId
                count+=1
            end
        end
        return count
    end
    
    
    def sellTool(toolId)
        i = 0
        for tool in tools
            if tool.id == toolId
                tools.delete_at(i)
                self.point += tool.cost
                puts "You sell a " + tool.name + " successfully."
                return
            end
            i+=1
        end
        raise RuntimeError, "You don't have this tool."
    end
    
private
    def buyLand(place)
        if self.money < place.price
            puts "you don't have enouge money to buy this land."
            return
        end
        
        Map.printMap
        puts "Do you want to buy this land(Y/N)? cost "+place.price.to_s
        input = gets
        input.chop!.downcase!
        if input == "y"
            place.type = self.id.to_s
            place.level = 0
            place.owner = self
            self.money-=place.price
        end
    end

    def addPoint(place)
        self.point += place.price
        puts "Aha,you got "+ place.price.to_s + " point."
    end
    
    def upgradeLand(place)
        if self.money < place.price
            puts "you don't have enouge money to upgrade this land."
            return
        end
        
        Map.printMap
        puts "Do you want to upgrade this land(Y/N)? cost "+place.price.to_s
        input = gets
        input.chop!.downcase!
        if input == "y"
            place.level += 1
            place.type = Player.playerLandType[self.id][place.level].chr
            self.money-=place.price
        end
    end
    
    def payFee(place)
        fee = 2 ** (place.level - 1) * place.price
        payfee = fee
        payfee = self.money if self.money < fee
        self.money -= fee
        place.owner.money += payfee
        puts "you pay " + payfee.to_s + "$ to " + place.owner.name

    end
        
    def addTool(tool)
        if self.point < tool.cost
            msg = sprintf("You don't have enough point to buy %s, which cost %d", tool.name ,tool.cost.to_s)
            raise  RuntimeError, msg
        end
        self.tools.push(tool)
        self.point -= tool.cost
        puts "You buy a "+tool.name + " successfully."
    end
    

    
            
    def buyTools
        while true
            if self.point < MIN_TOOL_POINT
                puts "You don't have enouge point to buy tool."
                break 
            end
            if self.tools.length >= MAX_TOOL_NUM
                puts "Your tool box is full.(10 most)"
                break
            end
            
            printf("Welcome to tool house,1:Block; 2: Bomb; 3: Robot.(You have %d point)\n", self.point)
            input = gets.chomp
            begin
                case input
                    when "F","f": break
                    when "1": addTool(Block.new(input,"block","#",BLOCK_POINT))
                    when "2": addTool(Bomb.new(input,"bomb","@",BOMB_POINT))
                    when "3": addTool(Robot.new(input,"robot","",ROBOT_POINT))
                    else puts "input error."; next
                end
            rescue =>ex
                puts ex.message
            end
            
        end
    end
    
    def getGift
        Map.printMap
        puts "Welcome to gift house,you can choose(1:2000$, 2:200 point, 3:lucky god)"
        input = gets
        case input.chomp
            when "1": self.money+=2000; puts "Aha,you got 2000$"
            when "2": self.point += 200; puts "Aha,you got 200 point"
            when "3": self.luckyDays = 5; puts "Aha,you got a lucky god"
            else puts "input error. you give up the chance."
        end
    end
    
    def checkLost
        if self.isLost?
            clearLands
            puts "Sorry, you lost."
            if Rich.isGameOver?
                Rich.nextPlayer
                Map.printMap
                puts Rich.currPlayer.name + " win!"
                `pause`
                exit 0
            end
        end
    end
    def clearLands
        for place in Map.map
            if place.owner == self
                Map.clearPlace(place)
            end
        end
    end
    
end



