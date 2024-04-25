 --!SerializeField
local gameManagerPrefab : GameObject = nil

--!SerializeField
local gameModePrefab : GameObject = nil 

function self:ServerStart()
    print("Spawner start on server")
    
    scene.PlayerJoined:Connect(function(scene, player)
        print(player.name .. " joined the scene in base spawner")
        --print("spawning manager and mode")
        local spawnPos : Vector3 = Vector3.new(0,0,0)
        local spawnRot : Vector3 = Vector3.new(0,0,0)
        --spawnPos = Vector3.new(0,0,0)
        --spawnRot = spawnPos;
        print("game manager is " .. gameManagerPrefab.name) -- it says concetanating nil 
        print(gameModePrefab.name)
        --Object.Instantiate(gameManagerPrefab)--, spawnPos, spawnRot); -- its crashing
        --Object.Instantiate(gameModePrefab)--, spawnPos, spawnRot);  -- crash
      --  print("spawnedddddddddd")
    end)

    scene.PlayerLeft:Connect(function(scene, player)
        print(player.name .. " left the scene")
        
    end)
end