-- LocalScript (place in StarterPlayerScripts or run in the command bar during Play mode)

-- ✅ Performance & physics improvements (Safe / Undetectable)
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Maximize simulation range (safe if not abuse

-- Disable post-processing effects (boost FPS)
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end

-- Lower rendering quality
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

-- Prevent parts from sleeping
for _, part in pairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        part:SetAttribute("NeverSleep", true)
    end
end

-- ⬇️ Original script (boosts, input, decals, stamina, etc.)

-- Infinite Stamina script
if(DisableNebulaRemoteAbuseAPI)then DisableNebulaRemoteAbuseAPI() end
local mt = getrawmetatable(game)
setreadonly(mt, false)
local nc = mt.__namecall
local intercepted = {}
local disabled = {}
local returns = {}

local namecallMethod = getnamecallmethod or get_namecall_method

local methods = {
    RemoteEvent = 'FireServer';
    RemoteFunction = 'InvokeServer';
    BindableEvent = 'Fire';
    BindableFunction = 'Invoke';
}

getgenv().InterceptRemoteArgs = function(eventorfunc, args)
    intercepted[eventorfunc] = args
end

getgenv().SpoofReturn = function(func, newReturn)
    returns[func] = newReturn
end

getgenv().DisableRemote = function(eventorfunc)
    disabled[eventorfunc] = true
end

getgenv().EnableRemote = function(eventorfunc)
    disabled[eventorfunc] = false
end

getgenv().DisableNebulaRemoteAbuseAPI = function()
    disabled = {}
    returns = {}
    intercepted = {}
    setreadonly(mt, false)
    mt.__namecall = nc
    setreadonly(mt, true)
end

mt.__namecall = newcclosure(function(self, ...)
    local Args = {...}
    local event = namecallMethod()
    if (methods[self.ClassName] == event) then
        if (disabled[self]) then
            return
        elseif (intercepted[self]) then
            local intercept = intercepted[self]
            if (typeof(intercept) == 'function') then
                Args = { intercept(unpack(Args)) }
            elseif (typeof(intercept) == 'table') then
                Args = intercept
            end
        end
    end
    local returned = { nc(self, unpack(Args)) }
    if (returns[self] and returned) then
        returned = { returns[self](unpack(returned)) }
    end
    return unpack(returned)
end)

setreadonly(mt, false)
local old = mt.__index

mt.__index = function(o, k)
    if tostring(o) == "Humanoid" and tostring(k) == "WalkSpeed" then
        return 16
    end
    return old(o, k)
end

wait(3)


InterceptRemoteArgs(game:GetService("ReplicatedStorage").FE.Sprint, function()
    return "Ended"
end)

local player = game.Players.LocalPlayer
player.Character.Humanoid.WalkSpeed = 22

local mouse = player:GetMouse()
mouse.KeyDown:Connect(function(activate)
    activate = activate:lower()
    if activate == "r" then
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

mouse.Button1Down:Connect(function()
    player.Character.Humanoid.WalkSpeed = 22
end)

-- LocalScript (place in StarterPlayerScripts or run in the command bar during Play mode)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Navigate safely to the target
local startGui = gui:FindFirstChild("Start")
if startGui then
	local points = startGui:FindFirstChild("Points")
	if points then
		local stamina = points:FindFirstChild("InstantStamina")
		if stamina then
			local textS = stamina:FindFirstChild("TextS")
			if textS then
				textS.Text = "Unlimited Stamina!"  -- Change the text here
			else
				warn("TextS not found")
			end
		else
			warn("InstantStamina not found")
		end
	else
		warn("Points not found")
	end
else
	warn("Start GUI not found")
end



-- ✅ Ball Interaction and Decal Removal
local UserInputService = game:GetService("UserInputService")
local reach = 0.9
local boxSize = Vector3.new(reach * 2, reach * 2, reach * 2)

local function interactWithBallsUsingBox(limb)
    if not player.Character or not player.Character:FindFirstChild(limb) then return end
    local limbPart = player.Character[limb]
    local cf = CFrame.new(limbPart.Position)
    local partsInBox = workspace:GetPartBoundsInBox(cf, boxSize)

    for _, part in pairs(partsInBox) do
        if (part.Name == "PSoccerBall" or part.Name == "TPS") then
            firetouchinterest(part, limbPart, 0)
            firetouchinterest(limbPart, part, 0)
            task.wait()
            firetouchinterest(part, limbPart, 1)
            firetouchinterest(limbPart, part, 1)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    local limbs = {"Right Leg", "Left Leg", "Right Arm", "Left Arm"}
    for _, limb in ipairs(limbs) do
        task.spawn(function()
            interactWithBallsUsingBox(limb)
        end)
    end
end)

local function modifyBallVelocities()
    local success, _ = pcall(function()
        if game.Workspace.TPSSystem:FindFirstChild("TPS") then
            game.Workspace.TPSSystem.TPS.Velocity = Vector3.new(100, 100, 100)
        end
    end)

    local ballFound = false
    if game.Workspace:FindFirstChild("Practice") then
        for _, soccerBall in pairs(game.Workspace.Practice:GetChildren()) do
            if soccerBall.Name == "PSoccerBall" and soccerBall:IsA("BasePart") then
                ballFound = true
                local success, _ = pcall(function()
                    soccerBall.Velocity = Vector3.new(100, 100, 100)
                end)
            end
        end
    end
end

local function setupLimbDecalRemoval(limb)
    local function removeDecal(descendant)
        if descendant:IsA("Decal") then
            descendant:Destroy()
        end
    end
    
    for _, descendant in ipairs(limb:GetDescendants()) do
        removeDecal(descendant)
    end
    
    limb.DescendantAdded:Connect(removeDecal)
end

local function removeDecalsFromCharacter(character)
    local targetLimbs = {
        "Right Leg",
        "Left Leg", 
        "Right Arm",
        "Left Arm"
    }
    
    for _, limbName in ipairs(targetLimbs) do
        local limb = character:FindFirstChild(limbName)
        if limb then
            setupLimbDecalRemoval(limb)
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(removeDecalsFromCharacter)
end)

for _, player in ipairs(game.Players:GetPlayers()) do
    if player.Character then
        removeDecalsFromCharacter(player.Character)
    end
end
