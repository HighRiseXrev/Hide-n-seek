--[[ --!SerializeField
local HiderPlayerPrefab : GameObject = nil

--!SerializeField
local SeekerPlayerPrefab : GameObject = nil ]]

local totalGameCurrency : number = 0 

function self:Start()
   
    if server then
        print("Gamemanager on server")
    end
    
end