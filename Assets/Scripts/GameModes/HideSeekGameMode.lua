--!SerializeField
local GameManagerObject : GameObject = nil

--!SerializeField
local totalGameTime : number = 5

local totalGameTimeSeconds = totalGameTime * 60

--!SerializeField
local totalNumberPlayersToStart : number = 5

local currentTime : number = 0

local playersJoinCount : number = 0

local IsGameFinished : boolean = false

local StartGame : boolean = false

addEnergyRequest = Event.new("AddEnergyRequest")--event to add when players joined all 5 to start match so it should spawn players
-- Server
function self:ServerAwake()

    totalNumberPlayersToStart = tonumber(totalNumberPlayersToStart)
    
    server.PlayerConnected:Connect(function(player)
        print(player.name .. " connected to the server")
    end)

    server.PlayerDisconnected:Connect(function(player)
        print(player.name .. " disconnected from the server")
    end)

end

scene.PlayerJoined:Connect(function(scene, player)
    print(player.name .. " joined the scene")
    print(player)
    playersJoinCount = playersJoinCount + 1
    print("player join count " .. playersJoinCount )
    print("total players to start " .. totalNumberPlayersToStart )
    SetPlayerType(player)
    if playersJoinCount >= totalNumberPlayersToStart then
        StartMatch()
    end
end)

scene.PlayerLeft:Connect(function(scene, player)
    print(player.name .. " left the scene")
    playersJoinCount = playersJoinCount - 1
end)

function SetPlayerType(player)
    print("setting player type")
    -- Check player object returning in functions and then set components based on decided type by server.
end

function self:ServerStart()
    print("Server start Game Mode")
    print("GameManager object on server is " .. GameManagerObject)
   -- GameManagerObject = GameObject.Find("GameManager")
   -- print("GameManager object is " .. GameManagerObject)
end
function self:ClientStart()
    print("CLient start game mode")
    print("GameManager object on client is " .. GameManagerObject.name)
end
function StartMatch()
    print("Match starting")
    StartGame = true
    -- UI disappear for lobby like players joining in UI etc
    SpawnPlayers()
end

function SpawnPlayers()
    print("Spawning Players")
   -- GameManagerObject:AddComponent("GameManager")
    --local hideSeekGameManager = GameManagerObject:GetComponent("GameManager")
    for i=1,totalNumberPlayersToStart do 
        --local tempGO = hideSeekGameManager.HiderPlayerPrefab
        local tempGO = GameObject.new()
        tempGO.name = "Spawntest"
        print("spawning objects")
    end
end

function self:ServerUpdate()
    if not StartGame then
        return
    end
    if IsGameFinished then
        return
    end
    print("This should run on the server")
    print("This frame took " .. Time.deltaTime .. " seconds")
    currentTime = currentTime + Time.deltaTime
    if currentTime >= totalGameTimeSeconds then
        GameOver()
    end
end

function GameOver()
    IsGameFinished = true
end
