--!SerializeField
local HiderPlayerPrefab : GameObject = nil

--!SerializeField
local SeekerPlayerPrefab : GameObject = nil

print("Testing the lua script,its like awake")

local totalGameCurrency : number = 0 

function self:Start()
    print("Start is calling")
    print("the game object name is " ..self.gameObject.name)
end