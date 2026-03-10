-[[look
Double Jump (Roblox Lua)
Place this LocalScript inside StarterCharacterScripts.
The player can trigger a second jump by pressing Space twice quickly.
--[[
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

local player = Players.LocalPlayer
local humanoid: Humanoid? = nil
local stateChangedConnection: RBXScriptConnection? = nil

local lastSpacePress = 0
local hasDoubleJumped = false

local function resetForGroundedState()
hasDoubleJumped = false
end
local GROUNDED_STATES = {
	[Enum.HumanoidStateType.Landed] = true,
	[Enum.HumanoidStateType.Running] = true,
	[Enum.HumanoidStateType.RunningNoPhysics] = true,
	[Enum.HumanoidStateType.Swimming] = true,
	[Enum.HumanoidStateType.Climbing] = true,
	[Enum.HumanoidStateType.Seated] = true,
}

local function onInputBegan(input: InputObject, gameProcessedEvent: boolean)
if gameProcessedEvent then
return
local function resetForGroundedState()
	hasDoubleJumped = false
end

if input.KeyCode ~= Enum.KeyCode.Space then    
	return    
end    
local function bindHumanoid(newCharacter: Model)
	if stateChangedConnection then
		stateChangedConnection:Disconnect()
		stateChangedConnection = nil
	end

local now = tick()    
local timeSinceLastPress = now - lastSpacePress    
lastSpacePress = now    
	humanoid = newCharacter:WaitForChild("Humanoid") :: Humanoid
	lastSpacePress = 0
	resetForGroundedState()

-- Only allow double jump while airborne and only once per airtime.    
if humanoid.FloorMaterial == Enum.Material.Air and not hasDoubleJumped and timeSinceLastPress <= DOUBLE_PRESS_WINDOW then    
	hasDoubleJumped = true    
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)    
	stateChangedConnection = humanoid.StateChanged:Connect(function(_, newState)
		if GROUNDED_STATES[newState] then
			resetForGroundedState()
		end
	end)
end

end
local function onInputBegan(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

humanoid.StateChanged:Connect(function(_, newState)
if newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running then
resetForGroundedState()
end
end)
	if input.UserInputType ~= Enum.UserInputType.Keyboard or input.KeyCode ~= Enum.KeyCode.Space then
		return
	end

player.CharacterAdded:Connect(function(newCharacter)
character = newCharacter
humanoid = character:WaitForChild("Humanoid")
lastSpacePress = 0
resetForGroundedState()
	if UserInputService:GetFocusedTextBox() then
		return
	end

humanoid.StateChanged:Connect(function(_, newState)    
	if newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running then    
		resetForGroundedState()    
	end    
end)
	if not humanoid then
		return
	end

end)
	local now = os.clock()
	local timeSinceLastPress = now - lastSpacePress
	lastSpacePress = now

	local state = humanoid:GetState()
	local isAirborne = state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping

	-- Only allow one extra jump while airborne and after a quick second press.
	if isAirborne and not hasDoubleJumped and timeSinceLastPress <= DOUBLE_PRESS_WINDOW then
		hasDoubleJumped = true
		humanoid.Jump = true
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

bindHumanoid(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(bindHumanoid)
UserInputService.InputBegan:Connect(onInputBegan)
