local repeatActions = true  -- Initial state to start actions

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local targetPlayerName = nil

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local playerDropdown = Instance.new("Frame")
playerDropdown.Size = UDim2.new(0, 150, 0, 200)
playerDropdown.Position = UDim2.new(1, -160, 0.5, -225)
playerDropdown.BackgroundTransparency = 0.5
playerDropdown.Parent = screenGui

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 1, 0)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Initialize CanvasSize
playerList.ScrollBarThickness = 10
playerList.Parent = playerDropdown

local function populatePlayerDropdown()
    playerList:ClearAllChildren()
    local yOffset = 0
    for _, player in ipairs(game.Players:GetPlayers()) do
        local playerButton = Instance.new("TextButton")
        playerButton.Size = UDim2.new(1, 0, 0, 30)
        playerButton.Position = UDim2.new(0, 0, 0, yOffset)
        playerButton.Text = player.Name
        playerButton.Parent = playerList
        playerButton.MouseButton1Click:Connect(function()
            targetPlayerName = player.Name
        end)
        yOffset = yOffset + 35
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

game.Players.PlayerAdded:Connect(function()
    populatePlayerDropdown()
end)

game.Players.PlayerRemoving:Connect(function()
    populatePlayerDropdown()
end)

populatePlayerDropdown()

-- Create the toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(1, -160, 0.5, -270)  -- Positioned directly above playerList
toggleButton.Text = "Toggle TP"
toggleButton.Parent = screenGui

local function toggleActions()
    repeatActions = not repeatActions
end

toggleButton.MouseButton1Click:Connect(toggleActions)

-- Calculate the position for the Teleport Up button
local teleportButtonYOffset = playerDropdown.AbsolutePosition.Y + playerDropdown.AbsoluteSize.Y + 10

-- Create the teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 100, 0, 50)
teleportButton.Position = UDim2.new(1, -160, 0, teleportButtonYOffset)  -- Positioned directly below playerList
teleportButton.Text = "Teleport Up"
teleportButton.Parent = screenGui

local function teleportUp()
    local height = 500  -- Adjust the height as needed

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local currentPos = player.Character.HumanoidRootPart.Position
        player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPos + Vector3.new(0, height, 0))
    end
end

teleportButton.MouseButton1Click:Connect(function()
    if repeatActions then
        teleportUp()
    end
end)

local function teleportBehindPlayer()
    while true do
        if repeatActions and targetPlayerName then
            local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
            if targetPlayer and targetPlayer.Character then
                local targetHumanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHumanoidRootPart then
                    local behindPosition = targetHumanoidRootPart.Position - (targetHumanoidRootPart.CFrame.lookVector * 3)
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(behindPosition, targetHumanoidRootPart.Position)
                end
            end
        end
        wait(0.005)
    end
end

local function simulateKeyPresses()
    local keys = {"One", "Two", "Three", "Four"}
    local index = 1

    while true do
        if repeatActions then
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
    while true do
        if repeatActions then
            local input = Instance.new("InputObject", game)
            input.UserInputType = Enum.UserInputType.MouseButton1
            input.Position = Vector2.new(0.5, 0.5)
            userInputService.InputBegan:Fire(input)
            wait(0.05)
            userInputService.InputEnded:Fire(input)
            input:Destroy()
        end
        wait(0.1)
    end
end

spawn(teleportBehindPlayer)
spawn(simulateKeyPresses)
spawn(simulateMouseClicks)
