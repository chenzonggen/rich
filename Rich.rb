require "Player"
require "Command"
DEFAULT_INIT_MONEY  = 10000
class Rich
    class << self 
    attr_accessor :init_money,:players,:currPlayer
    
    def initializeMoney
        begin
            self.init_money = DEFAULT_INIT_MONEY
            puts "Please input init money(1000~50000):"
            input = gets
            if input.chop == ""
                break
            end
            self.init_money = input.to_i
        end while (self.init_money<1000 || self.init_money > 50000 || input.chop != self.init_money.to_s)
        puts "The init money for all players is:" <<self.init_money.to_s
    end
   
    def initializePlayers
        @players = Array.new
        begin
            puts "Please choose 2~4 players(1.qianfuren,2.atubo,3.jinbeibei,4.sunxiaomei)"
            input = gets
        end while( notValidInput(input) or hasSamePlayers(input))
        initPlayersInfo(input)
        @currPlayer = @players[0]
    end
    
    def playerNum
        @players.size
    end
    
    def nextPlayer
        currPlayerIndex = 0
        for currPlayerIndex in 0 .. players.size
            if @currPlayer == players[currPlayerIndex]
                break
            end
        end
        begin
            currPlayerIndex = (currPlayerIndex+1)%players.size
            @currPlayer = players[currPlayerIndex]
        end while @currPlayer.isLost?
    end
    
    
    def gameRun
        while true
            print @currPlayer.id.to_s ,".", @currPlayer.name , ">"
            input = gets
            input.chomp!.downcase!
            begin
                firstWord = input.split(/ /)[0]
                
                if firstWord == nil
                    next
                elsif not Command.commandList.include?(firstWord)
                    raise NoMethodError
                end
                
                command = Command.new(input,@currPlayer)
                command.send(firstWord)
                Map.printMap

            rescue NoMethodError => ex 
                puts "Command Error:" + input
            rescue CommandError => ex
                puts ex.message
            rescue RuntimeError => ex
                puts ex.message
            end
        end
    end

    def isGameOver?
        livePlayerNum = self.playerNum
        for player in @players
            livePlayerNum-=1 if player.isLost?
        end
        livePlayerNum == 1
    end
    
        
    private
    def notValidInput(input)
        input.grep(/^[1|2|3|4]{2,4}$/).to_s != input
    end
    def hasSamePlayers(input)
        input.split(//).uniq != input.split(//)
    end
    
    def initPlayersInfo(input)
        playerIds = input.chop.split(//)
        i = 0
        for id in playerIds
            newPlayer = Player.new(id.to_i, Player.playerNames[id.to_i], Player.playerFlag[id.to_i],self.init_money)
            @players.insert(i,newPlayer)
            i+=1
        end
    end
end
end




#test