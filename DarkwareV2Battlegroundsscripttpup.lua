-- LocalScript placed in StarterPlayerScripts

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

-- Height to teleport
local teleportHeight = 1000

-- Function to teleport the player up in the sky
local function teleportUp()
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local currentPosition = humanoidRootPart.Position
            local newPosition = currentPosition + Vector3.new(0, teleportHeight, 0)
            humanoidRootPart.CFrame = CFrame.new(newPosition)
        end
    end
end

-- Bind the teleport function to a key press (e.g., "T")
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.T and not gameProcessed then
        teleportUp()
    end
end)
