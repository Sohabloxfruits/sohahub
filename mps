_G.x = false
local a = 1
local b = 20

local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/jensonhirst/Orion/main/source")))()
local Window =
    OrionLib:MakeWindow({Name = "Custom script", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local gTab = Window:MakeTab({Name = "GK", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local lvTab = Window:MakeTab({Name = "Level Spoofer", Icon = "rbxassetid://4483345998", PremiumOnly = false})

Tab:AddSlider({
	Name = "Distance Visuality",
	Min = 0,
	Max = 1,
	Default = 0.8,
	Color = Color3.fromRGB(255,255,255),
	Increment = 0.1,
	ValueName = "Distance Visuality",
	Callback = function(c)
		local d = game:GetService("RunService")
		local e = game.Players.LocalPlayer

		local f = Instance.new("Part")
		f.Shape = Enum.PartType.Ball
		f.Anchored = true
		f.CanCollide = false
		f.Transparency = c
		f.BrickColor = BrickColor.new("Bright blue")
		f.Parent = workspace

		d.RenderStepped:Connect(function()
			if e.Character and e.Character:FindFirstChild("HumanoidRootPart") then
				local g = e.Character.HumanoidRootPart
				f.Size = Vector3.new(a * 2, a * 2, a * 2)
				f.Position = g.Position
			else
				f.Size = Vector3.new(0, 0, 0)
			end
		end)
	end    
})

function createReachFunction(limb)
    return function()
        local d = game:GetService("RunService")
        d.RenderStepped:Connect(
            function()
                local e = game.Players.LocalPlayer
                if e.Character and e.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                    local g = e.Character.HumanoidRootPart
                    local h = game.Workspace.TPSSystem.TPS

                    if (g.Position - h.Position).Magnitude <= a then
                        firetouchinterest(e.Character[limb], h, 0)
                        firetouchinterest(e.Character[limb], h, 1)
                    end
                end
            end
        )
    end
end

Tab:AddButton({Name = "Right Leg reach", Callback = createReachFunction("Right Leg")})
Tab:AddButton({Name = "Left Leg reach", Callback = createReachFunction("Left Leg")})
Tab:AddButton({Name = "Right Arm reach", Callback = createReachFunction("Right Arm")})
Tab:AddButton({Name = "Left Arm reach", Callback = createReachFunction("Left Arm")})
Tab:AddButton({Name = "Head reach", Callback = createReachFunction("Head")})

Tab:AddButton(
    {
        Name = "Reach distance 1.7",
        Callback = function()
            a = 1.7
        end
    }
)

Tab:AddTextbox(
    {
        Name = "Enter Reach Distance",
        Default = "1",
        TextDisappear = true,
        Callback = function(c)
            local d = tonumber(c)
            if d then
                a = d
            else
                warn("off")
            end
        end
    }
)

gTab:AddToggle(
    {
        Name = "Auto save",
        Default = false,
        Callback = function(c)
            if c then
                print("on")
                _G.x = true
                while _G.x do
                    wait(0.8)
                    if
                        (game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                            game.Workspace.TPSSystem.TPS.Position).Magnitude <= b
                     then
                        game.Players.LocalPlayer.Character.Humanoid:MoveTo(
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Position +
                                Vector3.new(game.Workspace.TPSSystem.TPS.Position.X, 0, 0)
                        )
                        wait(0.8)
                        game.Players.LocalPlayer.Character.Humanoid:MoveTo(
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Position +
                                Vector3.new(-game.Workspace.TPSSystem.TPS.Position.X, 0, 0)
                        )
                    end
                end
            else
                print("off")
                _G.x = not _G.x
            end
        end
    }
)

gTab:AddTextbox(
    {
        Name = "Enter Ball Detection Distance",
        Default = "20",
        TextDisappear = true,
        Callback = function(c)
            local d = tonumber(c)
            if d then
                b = d
            else
                print("off")
            end
        end
    }
)

lvTab:AddTextbox({
	Name = "Level spoofer",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		local Targets
	Targets = tonumber(Value)
	wait(0.1)
	local mt = getrawmetatable(game);
setreadonly(mt, false);
local old_index = mt.__index;
mt.__index = function(a, b)
    if tostring(a) == "PPLevel" or tostring(a) == "Level" then
        if tostring(b) == "Value" then
            return Targets;
        end
    end
    return old_index(a, b);
end
	end	  
})

local BallModificationsTab = Window:MakeTab({
    Name = "Ball Modifications",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


local function getBalls()
    local balls = {}
    for _, child in pairs(workspace:GetDescendants()) do
        if child.Name == "PSoccerBall" and child:IsA("BasePart") then
            table.insert(balls, child)
        end
    end
    return balls
end


BallModificationsTab:AddSlider({
    Name = "Ball Size",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(value)
        for _, ball in pairs(getBalls()) do
            ball.Size = Vector3.new(value, value, value) -- Resize all balls
        end
    end
})


BallModificationsTab:AddColorpicker({
    Name = "Ball Color",
    Default = Color3.fromRGB(255, 255, 255), -- Default color is white
    Callback = function(color)
        for _, ball in pairs(getBalls()) do
            ball.Color = color -- Change color of all balls
        end
    end
})

BallModificationsTab:AddToggle(
    {
        Name = "Ball Collision",
        Default = false,
        Callback = function(z)
                for _, ball in pairs(getBalls()) do
                if z then
                    ball.CanCollide = true
                else
                    ball.CanCollide = false
                end
                end
        end
    }
)

workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "PSoccerBall" and descendant:IsA("BasePart") then
        descendant.Size = Vector3.new(2, 2, 2) -- Default size
        descendant.Color = Color3.fromRGB(255, 255, 255) -- Default color



local excludedNames = {
    "ComSFX1", "ComSFX2", "Match2", "Penalties1", "Match1", "ComSFX3", "ComSFX4", "ComSFX5", "ComSFX6", "ComSFX7",
    "Extra1", "Extra2", "Referee2Copy", "Match2a", "Match2b", "Referee2CopyR", "Penalties2", "Ref2STime", "Script3",
    "Script1", "Script2", "PHit1", "PHit2", "Tele1", "Tele2", "Tele3", "TeamAccept1", "TeamAccept2", "C7LocalScript",
    "PBMD1", "PBMD2", "PGMD1", "PGMD2", "PlayerP1", "PlayerP2", "Keep1", "Keep2", "C1LocalScript", "C2LocalScript",
    "C3LocalScript", "C4LocalScript", "C5LocalScript", "C6LocalScript", "Music1", "Music2", "Music3", "Music4", "Music5",
    "Music6", "Music7", "Music8", "Music9", "Music10", "Music11", "Music12", "Music13", "Music14", "Music15",
    "MenuButton1", "Crowd1", "Crowd2", "Crowd3", "Card1", "Card2", "Vib1", "Vib2", "Vib3", "Vib4", "Teleport1", "Teleport2"
}

local function isSusName(name)
   
    return name:match("^[a-zA-Z0-9]+$") and name:match("%d") and name:match("%a")
end

local function isExcluded(name)
    
    for _, excludedName in ipairs(excludedNames) do
        if name == excludedName then
            return true
        end
    end
    return false
end

local function Bypass()
    for _, object in pairs(game:GetDescendants()) do
        if object:IsA("Script") or object:IsA("LocalScript") then
            if isSusName(object.Name) and not isExcluded(object.Name) then
                object:Destroy()
            end
        end
    end
end

Bypass()




local function findAndDeleteScriptsWithHyphen()
    for _, object in pairs(game:GetDescendants()) do
        if object:IsA("Script") or object:IsA("LocalScript") then
            if object.Name:find("-") then
                object:Destroy()
            end
        end
    end
end

findAndDeleteScriptsWithHyphen()








 
 local function detectAndDeleteLocalScript()
        for _, child in pairs(workspace:GetDescendants()) do
            if child:IsA("LocalScript") then
                local scriptName = tonumber(child.Name)
                if scriptName and scriptName >= 1 and scriptName <= 999 then
                    child:Destroy()
                end
            end
        end
    end

    detectAndDeleteLocalScript()

    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("LocalScript") then
            local scriptName = tonumber(descendant.Name)
            if scriptName and scriptName >= 1 and scriptName <= 999 then
                descendant:Destroy()
            end
        end
    end)

    -- Anti-cheat bypasser for TPS

local a = getrawmetatable(game)
local b = a.__namecall
setreadonly(a, false)
a.__namecall = newcclosure(function(...)
    local c = {...}
    if not checkcaller() and getnamecallmethod() == "Kick" then
        return nil
    end
    return b(...)
end)
setreadonly(a, true)

local d = getrawmetatable(game)
local e = d.__namecall
setreadonly(d, false)
d.__namecall = newcclosure(function(f, ...)
    local g = tostring(getnamecallmethod())
    local h = {...}
    if not checkcaller() and g == "FireServer" and tostring(f) == "Banned" then
        return nil
    end
    return e(f, ...)
end)
setreadonly(d, true)

local i = getrawmetatable(game)
setreadonly(i, false)
local j = i.__index
i.__index = function(k, l)
    if tostring(k) == "BannedA" or tostring(k) == "BannedB" or tostring(k) == "BannedD" or tostring(k) == "BannedC" then
        if tostring(l) == "Value" then
            return false
        end
    end
    return j(k, l)
end

local m = getrawmetatable(game)
setreadonly(m, false)
local n = m.__index
m.__index = function(o, p)
    if tostring(o) == "BCount" then
        if tostring(p) == "Value" then
            return 0
        end
    end
    return n(o, p)
end

for q, r in pairs(game:GetService("Workspace").FE.Settings:GetChildren()) do
    if r.Name == "BName" then
        r:Destroy()
    end
end

    end
end)
