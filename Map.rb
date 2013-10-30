MAX_LEVEL = 3

class Place 
    attr_accessor :type,:owner,:level,:price,:row,:col
    def initialize(type,price,x,y)
        @type = type
        @row = x
        @col = y
        @level = -1
        @owner = nil
        @price = price    
    end
end

class Map
class << self
    attr_accessor :map, :mapChars,:mapPrice,:mapLength
    
    def clearPlace(place)
        place.level = -1
        place.type = "0"
        place.owner = nil
    end
    
    def printMap
        updateMap
        updatePlayers
        
        i = 0
        j = 0
        while i <  self.mapChars.length
            print  self.mapChars[i] 
            print "\tplayer\tmoney\tpoint\tposition\ttools" if j==0
            if j<=Rich.playerNum and j> 0 
                print "\t",Rich.players[j-1].name,"\t",Rich.players[j-1].money,"\t",Rich.players[j-1].point ,"\t",Rich.players[j-1].pos, \
                "\t\t",Rich.players[j-1].toolNum("1")," ,",Rich.players[j-1].toolNum("2")," ,",Rich.players[j-1].toolNum("3")
            end
        
            puts
            i+=1
            j+=1
        end
    end

    
    def initMap
        loadMap
        loadPrice
        @map = Array.new
        @mapLength = getMapLength(@mapChars)
        
        placeIndex = 0
        while placeIndex < @mapLength
            i = 0
            while i <  @mapChars.length
                j = 0
                while j < @mapChars[i].length
                    if @mapChars[i][j].chr == " "
                        j+=1
                        next
                    end
                    if placeIndex == 0 or isJoinedPlaces(i,j,@map[placeIndex-1])
                        newPlace = Place.new(@mapChars[i][j].chr,getPlacePrice(@mapChars[i][j].chr,@mapPrice[i][j].chr),i,j)
                        @mapChars[i][j] = " "
                        @map[placeIndex] = newPlace
                        placeIndex += 1
                    end
                    j+=1
                end
                i+=1
            end
        end
        printMap
    end
    
    private
    def getPlacePrice(type,chr)
        case type
            when "$":20 * chr.to_i
            when "0":100*chr.to_i
        end
    end
    
    def loadPrice
        file = File.open("price.txt")
        @mapPrice = Array.new
        file.each {|line| @mapPrice.push(line.chomp)}
        file.close
    end
    
    def loadMap
        mapFile = File.open("map.txt")
        @mapChars = Array.new
        mapFile.each {|line| @mapChars.push(line.chomp)}
        mapFile.close
    end
    
    def updatePlayers
        for player in Rich.players
            next if player.isLost?
            place = @map[player.pos]
            @mapChars[place.row][place.col] = player.flag
        end
        
    end
    
    def updateMap
        for place in @map
            @mapChars[place.row][place.col] = place.type
        end
    end
    def getMapLength(mapChars)
        mapLength = 0
        i = 0
        while i <  mapChars.length
            j = 0
            while j < mapChars[i].length
                if mapChars[i][j].chr != " "
                    mapLength+=1
                end
                j+=1
            end
            i+=1
        end
        return mapLength
    end
    
    def isJoinedPlaces(row,col,lastPlace)
        (row == lastPlace.row and  (col - lastPlace.col).abs == 1) \
        or (col == lastPlace.col and  (row- lastPlace.row).abs == 1)
        
    end
end
end
