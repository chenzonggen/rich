require "Rich"
require "Map"
def gameStart
    Rich.initializeMoney
    Rich.initializePlayers
    Map.initMap
    Rich.gameRun
end

gameStart