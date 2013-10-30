require "Player"
class CommandError < Exception
end

class Command
    attr_accessor :cmdStr,:currPlayer
    
    @@comamndList = ["roll","quit","help","block","robot","bomb","query","sell","selltool","money","point","pos"]
    
    def initialize(cmdStr,currPlayer)
        @cmdStr = cmdStr
        @currPlayer = currPlayer
    end
    
    def Command.commandList
        @@comamndList
    end
    
    def quit
        exit 0
    end
    
    def roll
        tokens = self.cmdStr.split(/ /)
        step = 1+ rand(6)
        if tokens.length >= 2
            step = tokens[1].to_i
            if tokens[1] != "0" and step == 0
                raise CommandError, "Please follow a number after roll"
            end
        end
        @currPlayer.pos = (@currPlayer.pos + step) % Map.mapLength
        puts "you go " + step.to_s + " steps, arride at position " + @currPlayer.pos.to_s
        @currPlayer.arrideAtPlace
         Rich.nextPlayer
    end
    
    def query
        puts "not support now, do you really need it?"
    end
    
    def sell
        tokens = self.cmdStr.split(/ /)
        if tokens.length >= 2
            raise CommandError, "could not follow a parameter for this command."
        end
        currPlace = Map.map[@currPlayer.pos]
        if currPlace.owner != @currPlayer
            raise CommandError, "could not sell this place."
        end
        sellFee = currPlace.price * (currPlace.level+1) * 2
        @currPlayer.money += sellFee
        Map.clearPlace(currPlace)
        puts "sell land at position "+@currPlayer.pos.to_s + " successfully, you get "+ sellFee.to_s + "$"
    end
    
    def selltool
        tokens = self.cmdStr.split(/ /)
        if tokens.length != 2
            raise CommandError, "Please follow the tool id after selltool."
        end
        @currPlayer.sellTool(tokens[1])
    end
    
    
    #################### Test Command ###################
    def money
        tokens = self.cmdStr.split(/ /)
        if tokens.length >= 2
            @currPlayer.money = tokens[1].to_i
        end
    end
    
    def point
        tokens = self.cmdStr.split(/ /)
        if tokens.length >= 2
            @currPlayer.point = tokens[1].to_i
        end
    end
    
    
    def pos
        tokens = self.cmdStr.split(/ /)
        if tokens.length >= 2
            @cmdStr = "roll "+( tokens[1].to_i - @currPlayer.pos).to_s
            roll
        end
    end
end

#~ class RollCommand < Command
     #~ def run(cmdStr)
         #~ step = rnad(6)
         #~ puts step
    #~ end   
#~ end

