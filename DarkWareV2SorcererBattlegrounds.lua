local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

-- Check if the place ID matches one of the specified values
local validPlaceIds = {10449761463, 13601434903}
local function isValidPlaceId(placeId)
    for _, id in ipairs(validPlaceIds) do
        if placeId == id then
            return true
        end
    end
    return false
end

if not isValidPlaceId(game.PlaceId) then
    return  -- Exit the script if the place ID does not match any valid ID
end

local targetPlayerName = nil
local originalPosition = nil  -- Variable to store the original position
local teleporting = false  -- Flag to track if teleporting is active
local repeatActions = true  -- Flag to control simulated key presses and mouse clicks
local walkSpeedEnabled = false  -- Flag to track if increased walk speed is active

-- Create a platform
local platformPosition = Vector3.new(0, 50, 0)  -- Adjust position as needed
local platformSize = Vector3.new(10, 1, 10)  -- Adjust size as needed

local platform = Instance.new("Part")
platform.Size = platformSize
platform.Position = platformPosition
platform.Anchored = true
platform.BrickColor = BrickColor.new("Bright blue")
platform.Parent = game.Workspace

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local topTextLabel = Instance.new("TextLabel")
topTextLabel.Size = UDim2.new(0, 200, 0, 20)
topTextLabel.Position = UDim2.new(0.5, -100, 0, 10)
topTextLabel.Text = "Made by @By A Dev"
topTextLabel.TextColor3 = Color3.new(1, 1, 1)
topTextLabel.BackgroundTransparency = 1
topTextLabel.TextScaled = true
topTextLabel.Parent = screenGui

local playerDropdown = Instance.new("Frame")
playerDropdown.Size = UDim2.new(0, 150, 0, 200)
playerDropdown.Position = UDim2.new(1, -160, 0.5, -225)
playerDropdown.BackgroundTransparency = 0.5
playerDropdown.Visible = true
playerDropdown.Parent = screenGui

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 1, 0)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 10
playerList.Parent = playerDropdown

local function populatePlayerDropdown()
    playerList:ClearAllChildren()
    local yOffset = 0
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local playerButton = Instance.new("TextButton")
            playerButton.Size = UDim2.new(1, 0, 0, 30)
            playerButton.Position = UDim2.new(0, 0, 0, yOffset)
            playerButton.Text = otherPlayer.Name
            playerButton.Parent = playerList
            playerButton.MouseButton1Click:Connect(function()
                targetPlayerName = otherPlayer.Name
            end)
            yOffset = yOffset + 35
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

local function showDropdown()
    playerDropdown.Visible = true
    populatePlayerDropdown()
end

local function hideDropdown()
    playerDropdown.Visible = false
end

local function setupGui()
    showDropdown()
    game.Players.PlayerAdded:Connect(populatePlayerDropdown)
    game.Players.PlayerRemoving:Connect(populatePlayerDropdown)
end

setupGui()

local teleportButtonYOffset = playerDropdown.Position.Y.Offset + playerDropdown.Size.Y.Offset + 10
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 100, 0, 50)
teleportButton.Position = UDim2.new(1, -160, 0, teleportButtonYOffset)
teleportButton.Text = "Teleport Up"
teleportButton.Parent = screenGui

teleportButton.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if not originalPosition then
            -- Store original position if not already stored
            originalPosition = player.Character.HumanoidRootPart.Position
        end

        if player.Character.HumanoidRootPart.Position == originalPosition then
            -- Teleport to platform
            player.Character.HumanoidRootPart.CFrame = CFrame.new(platform.Position + Vector3.new(0, platform.Size.Y / 2, 0))
        else
            -- Teleport back to original position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
            originalPosition = nil  -- Reset original position after teleporting back
        end
    end
end)

local toggleButtonYOffset = teleportButton.Position.Y.Offset + teleportButton.Size.Y.Offset + 10
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(1, -160, 0, toggleButtonYOffset)
toggleButton.Text = "Toggle TP"
toggleButton.Parent = screenGui

-- Function to teleport behind a player
local function teleportBehindPlayer()
    while teleporting do
        if targetPlayerName and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
            if targetPlayer and targetPlayer.Character then
                local targetHumanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHumanoidRootPart then
                    local behindPosition = targetHumanoidRootPart.Position - (targetHumanoidRootPart.CFrame.lookVector * 3)
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(behindPosition, targetHumanoidRootPart.Position)
                end
            end
        end
        wait(0.01)  -- Faster teleportation interval (adjust as needed)
    end
end

toggleButton.MouseButton1Click:Connect(function()
    -- Toggle teleport behind player functionality
    teleporting = not teleporting
    if teleporting then
        -- Start teleporting behind player
        spawn(teleportBehindPlayer)
    end
end)

local stopScriptButtonYOffset = toggleButton.Position.Y.Offset + toggleButton.Size.Y.Offset + 10
local stopScriptButton = Instance.new("TextButton")
stopScriptButton.Size = UDim2.new(0, 100, 0, 50)
stopScriptButton.Position = UDim2.new(1, -160, 0, stopScriptButtonYOffset)
stopScriptButton.Text = "Stop Script"
stopScriptButton.Parent = screenGui

-- Function to stop all actions and close GUI
local function stopScript()
    teleporting = false
    repeatActions = false
    walkSpeedEnabled = false
    
    -- Destroy all UI elements
    screenGui:Destroy()
end

stopScriptButton.MouseButton1Click:Connect(stopScript)

local toggleWalkSpeedButtonYOffset = stopScriptButton.Position.Y.Offset + stopScriptButton.Size.Y.Offset + 10
local toggleWalkSpeedButton = Instance.new("TextButton")
toggleWalkSpeedButton.Size = UDim2.new(0, 100, 0, 50)
toggleWalkSpeedButton.Position = UDim2.new(1, -160, 0, toggleWalkSpeedButtonYOffset)
toggleWalkSpeedButton.Text = "Toggle WalkSpeed"
toggleWalkSpeedButton.Parent = screenGui

local function setWalkSpeed()
    while walkSpeedEnabled do
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
        end
        wait(0.05)
    end
end

toggleWalkSpeedButton.MouseButton1Click:Connect(function()
    walkSpeedEnabled = not walkSpeedEnabled
    if walkSpeedEnabled then
        spawn(setWalkSpeed)
    else
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)

local function simulateKeyPresses()
    local keys = {"One", "Two", "Three", "Four"}
    local index = 1

    while repeatActions do
        if player and player.Character then
            local key = keys[index]
            userInputService.InputBegan:Fire({KeyCode = Enum.KeyCode[key]})
            wait(0.05)
            userInputService.InputEnded:Fire({KeyCode = Enum.KeyCode[key]})
            index = index % #keys + 1
            wait(0.05)
        else
            wait(0.1)
        end
    end
end

local function simulateMouseClicks()
    while repeatActions do
        if player and player.Character then
            local input = Instance.new("InputObject", game)
            input.UserInputType = Enum.UserInputType.MouseButton1
            input.Position = Vector2.new(0.5, 0.5)
            userInputService.InputBegan:Fire(input)
            wait(0.05)
            userInputService.InputEnded:Fire(input)
            input:Destroy()
        else
            wait(0.1)
        end
    end
end

spawn(simulateKeyPresses)
spawn(simulateMouseClicks)
