local repeatActions = true  -- Initial state to start actions
local teleportEnabled = false  -- Initial state for teleporting
local infiniteJumpEnabled = false  -- Initial state for infinite jump

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local targetPlayerName = nil

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create the toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(1, -110, 0.5, -125)
toggleButton.Text = "Toggle"
toggleButton.Parent = screenGui

-- Create the Infinite Jump toggle button
local infiniteJumpButton = Instance.new("TextButton")
infiniteJumpButton.Size = UDim2.new(0, 100, 0, 50)
infiniteJumpButton.Position = UDim2.new(1, -110, 0.5, -75)
infiniteJumpButton.Text = "Infinite Jump: OFF"
infiniteJumpButton.Parent = screenGui

-- Create the teleport toggle button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 100, 0, 50)
teleportButton.Position = UDim2.new(1, -110, 0.5, -25)
teleportButton.Text = "Teleport: OFF"
teleportButton.Parent = screenGui

-- Create the dropdown for player selection
local playerDropdown = Instance.new("Frame")
playerDropdown.Size = UDim2.new(0, 150, 0, 200)
playerDropdown.Position = UDim2.new(1, -160, 0.5, 75)
playerDropdown.BackgroundTransparency = 0.5
playerDropdown.Parent = screenGui

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 1, 0)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Initialize CanvasSize
playerList.ScrollBarThickness = 10
playerList.Parent = playerDropdown

local function toggleActions()
    repeatActions = not repeatActions
    
    if repeatActions then
        toggleButton.Text = "Toggle: ON"
    else
        toggleButton.Text = "Toggle: OFF"
    end
end

local function toggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        infiniteJumpButton.Text = "Infinite Jump: ON"
    else
        infiniteJumpButton.Text = "Infinite Jump: OFF"
    end
end

local function toggleTeleport()
    teleportEnabled = not teleportEnabled
    
    if teleportEnabled then
        teleportButton.Text = "Teleport: ON"
    else
        teleportButton.Text = "Teleport: OFF"
    end
end

toggleButton.MouseButton1Click:Connect(toggleActions)
infiniteJumpButton.MouseButton1Click:Connect(toggleInfiniteJump)
teleportButton.MouseButton1Click:Connect(toggleTeleport)

local function teleportBehindPlayer()
    while true do
        if repeatActions and teleportEnabled and targetPlayerName then
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

local function toggleInfiniteJumpAbility()
    while true do
        if infiniteJumpEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Check if the jump button is pressed
                if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
        wait(0.1)
    end
end

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

game.Players.PlayerAdded:Connect(function(player)
    populatePlayerDropdown()
end)

game.Players.PlayerRemoving:Connect(function(player)
    populatePlayerDropdown()
end)

populatePlayerDropdown()

spawn(teleportBehindPlayer)
spawn(simulateKeyPresses)
spawn(simulateMouseClicks)
spawn(toggleInfiniteJumpAbility)
