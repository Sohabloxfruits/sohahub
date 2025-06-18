local player = game:GetService("Players").LocalPlayer


    --// Execution Logger
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local MarketplaceService = game:GetService("MarketplaceService")
    local player = Players.LocalPlayer

    local function detectExecutor()
        local executorList = {
            {check = identifyexecutor, name = identifyexecutor and identifyexecutor()},
            {check = syn, name = "Synapse X"},
            {check = is_sirhurt_closure, name = "SirHurt"},
            {check = pebc_execute, name = "ProtoSmasher"},
            {check = secure_load, name = "Sentinel"},
            {check = KRNL_LOADED, name = "Krnl"},
            {check = wrapfunction and not islclosure, name = "Script-Ware"},
            {check = getexecutorname, name = getexecutorname and getexecutorname()},
            {check = OXYGEN_LOADED, name = "Oxygen U"},
            {check = WRD_LOADED, name = "WRD"},
            {check = shadow_env, name = "Shadow"},
            {check = fluxus, name = "Fluxus"},
            {check = isvm, name = "Delta"},
            {check = gethui, name = "Electron"},
        }
        for _, v in ipairs(executorList) do
            if v.check then
                return v.name
            end
        end
        return "Unknown"
    end

    local function sendExecutionLog()
        local success, gameInfo = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)

        local embed = {
            ["content"] = "",
            ["embeds"] = {
                {
                    ["title"] = "🔍 LadsHub Executed",
                    ["color"] = 0x00ff99,
                    ["fields"] = {
                        {name = "Username", value = player.Name, inline = true},
                        {name = "Display Name", value = player.DisplayName, inline = true},
                        {name = "Account Age", value = tostring(player.AccountAge).." days", inline = true},
                        {name = "Premium", value = tostring(player.MembershipType == Enum.MembershipType.Premium), inline = true},
                        {name = "Executor", value = detectExecutor(), inline = true},
                        {name = "Game", value = success and gameInfo.Name or "Unknown", inline = false},
                        {name = "Time", value = os.date("%c"), inline = false}
                    }
                }
            }
        }

        pcall(function()
            request({
                Url = "https://canary.discord.com/api/webhooks/1380523583993942056/007dXL1bEJYBbgW3_xk4M3aT_f8UKvcZGHiKVhEJjQVTTK6ONKR_0mn8n2cdhoiohiSE", -- Replace this with your Discord webhook
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(embed)
            })
        end)
    end

    sendExecutionLog()

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

-- Globals
_G.x = false
local a = 1
local b = 20

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib(" LadsHub ", "Ocean")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Anti-Cheat Bypass Script

local deletedScripts = {}
local foundScripts = false

local function scriptHasAntiCheatKeyword(scriptObj)
    if typeof(scriptObj) ~= "Instance" or not scriptObj:IsA("LuaSourceContainer") then return false end
    local success, source = pcall(function() return scriptObj.Source end)
    if not success or typeof(source) ~= "string" then return false end
    return source:find("Banned") or source:find("Walkspeed")
end

-- Destroy all scripts with anti-cheat keywords in the source
for _, obj in ipairs(game:GetDescendants()) do
    if (obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("Script")) and not deletedScripts[obj] then
        if scriptHasAntiCheatKeyword(obj) then
            obj:Destroy()
            deletedScripts[obj] = true
            foundScripts = true
        end
    end
end

-- Listen for new scripts added and destroy if they have anti-cheat keywords
game.DescendantAdded:Connect(function(obj)
    if (obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("Script")) then
        if scriptHasAntiCheatKeyword(obj) then
            obj:Destroy()
        end
    end
end)

-- Prevent getting kicked
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and method == "Kick" then
        return nil -- block kicks
    end
    if not checkcaller() and method == "FireServer" and tostring(self) == "Banned" then
        return nil -- block remote event that triggers ban
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- Prevent anti-cheat from detecting size changes on TPS and PSoccerBall
local function protectBallSize(ballName)
    local ball = workspace:FindFirstChild(ballName)
    if ball and ball:IsA("BasePart") then
        local currentSize = ball.Size
        ball:GetPropertyChangedSignal("Size"):Connect(function()
            if ball.Size ~= currentSize then
                ball.Size = currentSize -- revert size if changed by anti-cheat
            end
        end)
    end
end

protectBallSize("TPS")
protectBallSize("PSoccerBall")

if not foundScripts then
    print("No anti-cheat scripts found to destroy.")
end


local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Reach Settings")

local GKTab = Window:NewTab("GK")
local GKSection = GKTab:NewSection("GK Auto Save")

local SpoofTab = Window:NewTab("Level Spoofer")
local SpoofSection = SpoofTab:NewSection("Spoof Tools")

local StaminaTab = Window:NewTab("Stamina")
local StaminaSection = StaminaTab:NewSection("Stamina Hacks")

local FPSTab = Window:NewTab("FPS")
local FPSSection = FPSTab:NewSection("Performance Booster")

local MiscTab = Window:NewTab("Miscellaneous")
local MiscSection = MiscTab:NewSection("Fun Tools and Utilities")

-- New username avatar fetcher in Misc tab
MiscSection:NewTextBox("Player Avatar Fetcher", "Enter Username to get avatar", function(value)
    if typeof(value) ~= "string" or value == "" then
        warn("Please enter a valid username.")
        return
    end

    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local playerUserName = value

    -- Getting UserId from username using Roblox API
    local success, result = pcall(function()
        local url = "https://api.roblox.com/users/get-by-username?username=" .. playerUserName
        local response = game:HttpGet(url)
        return HttpService:JSONDecode(response)
    end)

    if success and result and result.Id then
        local userId = result.Id

        -- Display avatar using InsertService Insert with Headshot/request
        local thumbnailUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"

        -- Show notification or UI image for avatar
        print("[Avatar Fetcher] Got avatar URL for user '" .. playerUserName .. "': " .. thumbnailUrl)

        -- Create a ScreenGui with ImageLabel to show avatar in PlayerGui
        local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

        -- Remove existing avatar container if any
        local existingGui = playerGui:FindFirstChild("AvatarFetcherGui")
        if existingGui then
            existingGui:Destroy()
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AvatarFetcherGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui

        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Size = UDim2.new(0, 150, 0, 150)
        imageLabel.Position = UDim2.new(1, -170, 1, -170) -- Bottom-right corner offset
        imageLabel.BackgroundTransparency = 0.2
        imageLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
        imageLabel.BorderSizePixel = 1
        imageLabel.BorderColor3 = Color3.fromRGB(0,0,0)
        imageLabel.Image = thumbnailUrl
        imageLabel.Parent = screenGui

        -- Optionally add a close button
        local closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -30, 1, -170)
        closeButton.Text = "X"
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        closeButton.TextColor3 = Color3.new(1,1,1)
        closeButton.Parent = screenGui
        closeButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)

        -- Note: Making avatar change visible to all players requires game server scripts and is not feasible client-side only.
        -- You can attempt to replace your character appearance parts but broadcasting it is server controlled.

    else
        warn("Failed to fetch user info for username '" .. playerUserName .. "'. User may not exist.")
    end
end)

-- Reach tab
MainSection:NewSlider("Distance Visuality", "Adjusts visibility of ball radius", 1, 0, function(c)
    local RunService = game:GetService("RunService")
    local Player = game.Players.LocalPlayer

    local f = Instance.new("Part")
    f.Shape = Enum.PartType.Ball
    f.Anchored = true
    f.CanCollide = false
    f.Transparency = c
    f.BrickColor = BrickColor.new("Bright blue")
    f.Parent = workspace

    RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local root = Player.Character.HumanoidRootPart
            f.Size = Vector3.new(a * 2, a * 2, a * 2)
            f.Position = root.Position
        else
            f.Size = Vector3.new(0, 0, 0)
        end
    end)
end)

function createReachFunction(limb)
    return function()
        local RunService = game:GetService("RunService")
        RunService.RenderStepped:Connect(function()
            local Player = game.Players.LocalPlayer
            if Player.Character and Player.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                local root = Player.Character.HumanoidRootPart
                local ball = workspace:FindFirstChild("TPSSystem") and workspace.TPSSystem:FindFirstChild("TPS")
                if ball and (root.Position - ball.Position).Magnitude <= a then
                    firetouchinterest(Player.Character[limb], ball, 0)
                    firetouchinterest(Player.Character[limb], ball, 1)
                end
            end
        end)
    end
end

MainSection:NewButton("Right Leg reach", "Touch ball with right leg", createReachFunction("Right Leg"))
MainSection:NewButton("Left Leg reach", "Touch ball with left leg", createReachFunction("Left Leg"))
MainSection:NewButton("Right Arm reach", "Touch ball with right arm", createReachFunction("Right Arm"))
MainSection:NewButton("Left Arm reach", "Touch ball with left arm", createReachFunction("Left Arm"))
MainSection:NewButton("Head reach", "Touch ball with head", createReachFunction("Head"))
MainSection:NewButton("Reach distance 1.7", "Sets reach to 1.7", function() a = 1.7 end)
MainSection:NewTextBox("Enter Reach Distance", "Custom reach radius", function(value)
    local d = tonumber(value)
    if d then a = d else warn("Invalid number") end
end)

-- GK Auto Save
GKSection:NewToggle("Auto save", "Auto movement when near ball", function(state)
    _G.x = state
    if state then
        while _G.x do
            wait(0.8)
            local Player = game.Players.LocalPlayer
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            local ball = workspace:FindFirstChild("TPSSystem") and workspace.TPSSystem:FindFirstChild("TPS")
            if root and ball and (root.Position - ball.Position).Magnitude <= b then
                Player.Character.Humanoid:MoveTo(root.Position + Vector3.new(ball.Position.X, 0, 0))
                wait(0.8)
                Player.Character.Humanoid:MoveTo(root.Position + Vector3.new(-ball.Position.X, 0, 0))
            end
        end
    end
end)

GKSection:NewTextBox("Ball Detection Distance", "Default is 20", function(value)
    local d = tonumber(value)
    if d then b = d else print("Invalid number") end
end)

-- Level Spoofer
SpoofSection:NewTextBox("Level spoofer", "Fake level value", function(Value)
    local Targets = tonumber(Value)
    wait(0.1)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old_index = mt.__index
    mt.__index = function(a, b)
        if tostring(a) == "PPLevel" or tostring(a) == "Level" then
            if tostring(b) == "Value" then return Targets end
        end
        return old_index(a, b)
    end
end)

-- Infinite Stamina
StaminaSection:NewToggle("Infinite Stamina", "Removes stamina depletion and spoof remotes", function(state)
    if state then
        if (DisableNebulaRemoteAbuseAPI) then DisableNebulaRemoteAbuseAPI() end
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
        getgenv().InterceptRemoteArgs = function(eventorfunc, args) intercepted[eventorfunc] = args end
        getgenv().SpoofReturn = function(func, newReturn) returns[func] = newReturn end
        getgenv().DisableRemote = function(eventorfunc) disabled[eventorfunc] = true end
        getgenv().EnableRemote = function(eventorfunc) disabled[eventorfunc] = false end
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
                if (disabled[self]) then return
                elseif (intercepted[self]) then
                    local intercept = intercepted[self]
                    if (typeof(intercept) == 'function') then Args = { intercept(unpack(Args)) }
                    elseif (typeof(intercept) == 'table') then Args = intercept end
                end
            end
            local returned = { nc(self, unpack(Args)) }
            if (returns[self] and returned) then returned = { returns[self](unpack(returned)) } end
            return unpack(returned)
        end)
        local old = mt.__index
        mt.__index = function(o, k)
            if tostring(o) == "Humanoid" and tostring(k) == "WalkSpeed" then return 16 end
            return old(o, k)
        end
        wait(3)
        InterceptRemoteArgs(game:GetService("ReplicatedStorage").FE.Sprint, function() return "Ended" end)
        local player = game.Players.LocalPlayer
        player.Character.Humanoid.WalkSpeed = 22
        local mouse = player:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key:lower() == "r" then player.Character.Humanoid.WalkSpeed = 16 end
        end)
        mouse.Button1Down:Connect(function()
            player.Character.Humanoid.WalkSpeed = 22
        end)
        local gui = player:WaitForChild("PlayerGui")
        local startGui = gui:FindFirstChild("Start")
        if startGui then
            local points = startGui:FindFirstChild("Points")
            if points then
                local stamina = points:FindFirstChild("InstantStamina")
                if stamina and stamina:FindFirstChild("TextS") then
                    stamina.TextS.Text = "Unlimited Stamina!"
                end
            end
        end
    end
end)

-- Anti Vote-Kick
StaminaSection:NewToggle("Anti Vote-Kick", "Destroys any vote-kick GUI or event", function(state)
    if state then
        local function destroyKickObjects()
            local containers = {
                game.Players.LocalPlayer.PlayerGui,
                game:GetService("ReplicatedStorage"),
                game:GetService("CoreGui"),
                game:GetService("Lighting"),
                game.Workspace
            }
            for _, container in pairs(containers) do
                for _, child in pairs(container:GetDescendants()) do
                    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("TextLabel") or child:IsA("ScreenGui") then
                        if string.lower(child.Name):find("kick") then
                            pcall(function() child:Destroy() end)
                        end
                    end
                end
            end
        end

        -- Run loop
        spawn(function()
            while true do
                task.wait(50)
                if not state then break end
                destroyKickObjects()
            end
        end)
    end
end)

-- FPS Tab
local fpsLabel = nil
local runningFPS = false
local RunService = game:GetService("RunService")

local function optimizeFPS()
    pcall(function()
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.Brightness = 1
        Lighting.ExposureCompensation = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)

        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = false
            end
        end

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 0.9
            end
        end
    end)
end

FPSSection:NewButton("Optimize FPS", "Apply FPS boosting settings", function()
    optimizeFPS()
    print("FPS optimization applied!")
end)

local ballTab = Window:NewTab("Ball Modifications")
local ballSection = ballTab:NewSection("Ball Modification")

ballSection:NewSlider("Ball Size", "Adjust TPS Ball Size", 20, 1, function(val)
    if workspace.TPSSystem and workspace.TPSSystem:FindFirstChild("TPS") then
        pcall(function()
            workspace.TPSSystem.TPS.Size = Vector3.new(val, val, val)
        end)
    end
end)

ballSection:NewSlider("PSoccerBall Size", "Adjust Practice Soccer Ball Size", 20, 1, function(val)
    if typeof(val) ~= "number" or val < 1 or val > 20 then return end
    local practice = workspace:FindFirstChild("Practice")
    if not practice then return end
    for _, ball in ipairs(practice:GetChildren()) do
        if ball:IsA("BasePart") and ball.Name == "PSoccerBall" then
            pcall(function()
                ball.Size = Vector3.new(val, val, val)
            end)
        end
    end
end)

local PhysicsService = game:GetService("PhysicsService")

ballSection:NewToggle("TPS Collision Group", "Toggle TPS or PSoccerBall Collision Group", false, function(val)
    local balls = {}

    -- Find TPS ball if exists
    local tps = workspace:FindFirstChild("TPS")
    if tps then
        table.insert(balls, tps)
    end

    -- Find PSoccerBall if exists
    local psoccer = workspace:FindFirstChild("PSoccerBall")
    if psoccer then
        table.insert(balls, psoccer)
    end

    -- Set collision group for each ball part
    for _, ball in ipairs(balls) do
        -- Make sure the ball is a BasePart before changing CollisionGroup
        if ball:IsA("BasePart") then
            ball.CollisionGroup = val and "All" or "Ball"
        end
    end

    -- Set collision between Players and ball group depending on toggle
    if val then
        PhysicsService:CollisionGroupSetCollidable("Players", "All", true)
    else
        PhysicsService:CollisionGroupSetCollidable("Players", "Ball", true)
    end
end)



ballSection:NewToggle("Soccer Ball Collision Group", "Toggle Practice Soccer Ball Collision Group", false, function(val)
    local practice = workspace:FindFirstChild("Practice")
    if not practice then return end
    for _, ball in ipairs(practice:GetChildren()) do
        if ball:IsA("BasePart") and ball.Name == "PSoccerBall" then
            pcall(function()
                ball.CollisionGroup = val and "All" or "Ball"
            end)
        end
    end
end)

local ReactTab = Window:NewTab("React Booster")
local ReactSection = ReactTab:NewSection("React Scripts")

ReactSection:NewLabel("Once you press a button, YOU CANNOT TURN IT OFF")

ReactSection:NewToggle("Enhanced Reaction", function()
    print("Enhanced Reaction clicked")
    local mt = getrawmetatable(game)
    local oldNC = mt.__namecall
    local getnamecallmethod = getnamecallmethod or function() return "" end

    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = ""
        pcall(function() method = getnamecallmethod() end)

        if not checkcaller() and method == "FireServer" and self == workspace.FE.Scorer.RemoteEvent then
            pcall(function()
                workspace.FE.Scorer.RemoteEvent1:FireServer(table.unpack(args))
                workspace.FE.Scorer.RemoteEvent2:FireServer(table.unpack(args))
            end)
            return
        end

        return oldNC(self, table.unpack(args))
    end)
    setreadonly(mt, true)
end)


ReactSection:NewToggle("Improved Hit Detection", function()
    print("Improved Hit Detection clicked")
    local mt = getrawmetatable(game)
    local oldNC = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if not checkcaller() and getnamecallmethod() == "FireServer" and self == workspace.FE.Scorer.RemoteEvent then
            for i = 1, 3 do
                pcall(function()
                    workspace.FE.Scorer.RemoteEvent1:FireServer(table.unpack(args))
                    workspace.FE.Scorer.RemoteEvent:FireServer(table.unpack(args))
                end)
            end
            return
        end
        return oldNC(self, table.unpack(args))
    end)
    setreadonly(mt, true)
end)

ReactSection:NewToggle("Reaction Enhancer", function()
    print("Reaction Enhancer clicked")
    local mt = getrawmetatable(game)
    local oldNC = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if not checkcaller() and getnamecallmethod() == "FireServer" and self == workspace.FE.Scorer.RemoteEvent then
            for i = 1, 10 do
                if workspace:FindFirstChild("FE") then
                    local fe = workspace.FE
                    if fe:FindFirstChild("Keep") and fe.Keep:FindFirstChild("GK") then
                        pcall(function() fe.Keep.GK:FireServer(table.unpack(args)) end)
                    end
                    if fe:FindFirstChild("GK") then
                        if fe.GK:FindFirstChild("BGKSaves") then pcall(function() fe.GK.BGKSaves:FireServer(table.unpack(args)) end) end
                        if fe.GK:FindFirstChild("BGKP") then pcall(function() fe.GK.BGKP:FireServer(table.unpack(args)) end) end
                        if fe.GK:FindFirstChild("GGKP") then pcall(function() fe.GK.GGKP:FireServer(table.unpack(args)) end) end
                    end
                end
            end
            return
        end
        return oldNC(self, table.unpack(args))
    end)
    setreadonly(mt, true)
end)

ReactSection:NewButton("Velocity Booster", function()
    print("Velocity Booster clicked")
    local success, _ = pcall(function()
        game.Workspace.TPSSystem.TPS.Velocity = Vector3.new(100, 100, 100)
    end)

    for _, soccerBall in pairs(game.Workspace.Practice:GetChildren()) do
        if soccerBall.Name == "PSoccerBall" and soccerBall:IsA("BasePart") then
            pcall(function()
                soccerBall.Velocity = Vector3.new(100, 100, 100)
            end)
        end
    end
end)
