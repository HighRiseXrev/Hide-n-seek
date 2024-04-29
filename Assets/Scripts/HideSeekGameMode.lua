--!SerializeField
local HiderPlayerPrefab : GameObject = nil

--!SerializeField
local SeekerPlayerPrefab : GameObject = nil

--!SerializeField
local totalGameTime : number = 5

local totalGameTimeSeconds = totalGameTime * 60

--!SerializeField
local totalNumberPlayersToStart : number = 5

local currentTime : number = 0

local playersJoinCount : number = 0

local IsGameFinished : boolean = false

local StartGame : boolean = false

local maxSeekerCount : number = 2

local currentSeekerCount : number = 0

players = {}

playerTypeCount = {}

addEnergyRequest = Event.new("AddEnergyRequest")--event to add when players joined all 5 to start match so it should spawn players

function self:ServerAwake()
    print("Server Awake Game Mode")
    totalNumberPlayersToStart = tonumber(totalNumberPlayersToStart)

    
    server.PlayerConnected:Connect(function(player)
        print(player.name .. " connected to the server")
    end)

    server.PlayerDisconnected:Connect(function(player)
        print(player.name .. " disconnected from the server")
    end)
end

function self:ServerStart()
    print("Server start Game Mode")
   -- SetGameMangerObjectReference()
    scene.PlayerJoined:Connect(function(scene, player)
        print(player.name .. " joined the scene")

        playersJoinCount = playersJoinCount + 1
        print("player join count " .. playersJoinCount)
        print("total players to join " .. totalNumberPlayersToStart)

        players[player] = {
            player = player,
            playerType = SetPlayerType()
        }

        if playersJoinCount >= totalNumberPlayersToStart then
            StartMatch()
        end
    end)

    scene.PlayerLeft:Connect(function(scene, player)
        print(player.name .. " left the scene")
        playersJoinCount = playersJoinCount - 1
    end)
end

function SetGameMangerObjectReference()
    local gameManagers = GameObject.FindGameObjectsWithTag("GameManager")
       if (#gameManagers > 0) then
            print("found gamemanagers")
            print("gamemanager at 1 is " .. gameManagers[1].name) --Array index starts at 1 not 0 -- damn
            local gM : GameObject = nil;
            gM = gameManagers[1]
            local gameManager = gameManagers[1]
            print("gamemanager name is " .. gameManager.name)
            print("type is " .. type(gameManager))
            print("type of gm is " .. type(gM)) 
            prefabToSpawn = gameManager.gameObject:GetComponent("GameManager").HiderPlayerPrefab -- getcomponent doesnt work on server for now
            print("prefab to spawn name is " .. prefabToSpawn.name)
       end
    end

function SetPlayerType()
    print("setting player type")
    -- Check player object returning in functions and then set components based on decided type by server.
    
    local randomType = math.random(0, 1) -- 0->Hider 1->Seeker
    print("random type " .. randomType)
    if randomType == 1 then
        currentSeekerCount = currentSeekerCount + 1
        if currentSeekerCount > maxSeekerCount then
            randomType = 0
        end
    end
        
    return randomType
end

function self:ClientStart()
    print("Client start game mode")
  --  if gameManagerPrefab ~= nil then
      --  print("GameManager object on client is " .. gameManagerPrefab.name)
   -- else
   --     print("GameManager prefab is not set")
   -- end
end

function StartMatch()
    print("Match starting")
    StartGame = true
    -- UI disappear for lobby like players joining in UI, etc.
    SpawnPlayers()
end

function SpawnPlayers()
    print("Spawning Players")

    local currentCounHider : number = 1
    local currentCounSeeker : number = 1
    local hiderSpawns = GameObject.FindGameObjectsWithTag("HiderSpawnPoint")
    local SeekerSpawns = GameObject.FindGameObjectsWithTag("SeekerSpawnPoint")
    local spawnTransform : Transform = nil;
    local spawnPos : Vector3 = nil;
    local spawnRot : Vector3 = nil;

    for player,playerinfo in pairs(players) do
        print(player.name .. ", player type: " .. playerinfo.playerType)
       
        if(playerinfo.playerType <= 0) then
            if (#hiderSpawns > 0) then
                spawnTransform = hiderSpawns[currentCounHider].transform
                spawnPos = spawnTransform.position
                spawnRot = spawnTransform.eulerAngles
                currentCounHider = currentCounHider + 1
            else
                spawnPos = Vector3.new(0,0,0)
                spawnRot = spawnPos;
            end
            player.character = Object.Instantiate(HiderPlayerPrefab, spawnPos, spawnRot);
        else
            if (#SeekerSpawns > 0) then
                spawnTransform = SeekerSpawns[currentCounSeeker].transform
                spawnPos = spawnTransform.position
                spawnRot = spawnTransform.eulerAngles
                currentCounSeeker = currentCounSeeker + 1
            else
                spawnPos = Vector3.new(0,0,0)
                spawnRot = spawnPos;
            end
            player.character = Object.Instantiate(SeekerPlayerPrefab, spawnPos, spawnRot);
       end
    end
end

function self:ServerUpdate()

    if not StartGame or IsGameFinished then
        return
    end

    print("timer should run on the server")
    print("This frame took " .. Time.deltaTime .. " seconds")
    currentTime = currentTime + Time.deltaTime

    if currentTime >= totalGameTimeSeconds then
        GameOver()
    end
end

function GameOver()
    IsGameFinished = true
end