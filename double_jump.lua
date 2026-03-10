-[[look
Double Jump (Roblox Lua)
Place this LocalScript inside StarterCharacterScripts.
The player can trigger a second jump by pressing Space twice quickly.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local DOUBLE_PRESS_WINDOW = 0.35 -- Max time between first and second Space press

local lastSpacePress = 0
local hasDoubleJumped = false

local function resetForGroundedState()
hasDoubleJumped = false
end

local function onInputBegan(input: InputObject, gameProcessedEvent: boolean)
if gameProcessedEvent then
return
end

if input.KeyCode ~= Enum.KeyCode.Space then    
	return    
end    

local now = tick()    
local timeSinceLastPress = now - lastSpacePress    
lastSpacePress = now    

-- Only allow double jump while airborne and only once per airtime.    
if humanoid.FloorMaterial == Enum.Material.Air and not hasDoubleJumped and timeSinceLastPress <= DOUBLE_PRESS_WINDOW then    
	hasDoubleJumped = true    
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)    
end

end

humanoid.StateChanged:Connect(function(_, newState)
if newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running then
resetForGroundedState()
end
end)

player.CharacterAdded:Connect(function(newCharacter)
character = newCharacter
humanoid = character:WaitForChild("Humanoid")
lastSpacePress = 0
resetForGroundedState()

humanoid.StateChanged:Connect(function(_, newState)    
	if newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running then    
		resetForGroundedState()    
	end    
end)

end)

UserInputService.InputBegan:Connect(onInputBegan)
