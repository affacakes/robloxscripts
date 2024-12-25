-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Global Configuration
_G.TeamHitboxSmall = _G.TeamHitboxSmall or false
_G.FriendsHitboxSmall = _G.FriendsHitboxSmall or false
_G.NormalPlayersSmall = _G.NormalPlayersSmall or false
_G.Disabled = _G.Disabled or false
_G.HeadSize = _G.HeadSize or 50

-- Default hitbox size
local DEFAULT_HEAD_SIZE = 50
local SMALL_HEAD_SIZE = 25

-- GUI variables
local gui = nil

-- Functions
local function toggleHeadSize(player, size)
    if player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        head.Size = Vector3.new(size, size, size)
        if head:FindFirstChild("Mesh") then
            head.Mesh:Destroy()
        end
        head.CanCollide = false
    end
end

local function adjustHitboxes()
    if _G.Disabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local isFriend = player:IsFriendsWith(Players.LocalPlayer.UserId)
            local isTeam = player.Team == Players.LocalPlayer.Team

            if isTeam and _G.TeamHitboxSmall then
                toggleHeadSize(player, SMALL_HEAD_SIZE)
            elseif isFriend and _G.FriendsHitboxSmall then
                toggleHeadSize(player, SMALL_HEAD_SIZE)
            elseif _G.NormalPlayersSmall then
                toggleHeadSize(player, SMALL_HEAD_SIZE)
            else
                toggleHeadSize(player, DEFAULT_HEAD_SIZE)
            end
        end
    end
end

-- Hotkey Display Function
local function displayHitboxMenu()
    print("[H] Toggle Team Hitbox Size")
    print("[Y] Toggle Default Hitbox Size")
    print("[U] Display Hitbox Menu")
    print("[Z] Toggle Friends and Normal Players Hitbox Size")
    print("[I] Disable/Enable Hitbox Adjustments")
end

-- Function to open hitbox size selection GUI
local function openHitboxSelectionMenu()
    if gui then
        gui:Destroy()
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "HitboxSelectionMenu"
    gui.Parent = game.Players.LocalPlayer.PlayerGui

    -- Create frame for the menu
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Parent = gui

    -- Create close button (X)
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Parent = frame
    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Create button to set hitbox to 25
    local smallButton = Instance.new("TextButton")
    smallButton.Size = UDim2.new(0, 180, 0, 40)
    smallButton.Position = UDim2.new(0, 10, 0, 20)
    smallButton.Text = "Set Default Hitbox Size to 25"
    smallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    smallButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    smallButton.Parent = frame
    smallButton.MouseButton1Click:Connect(function()
        _G.HeadSize = SMALL_HEAD_SIZE
        print("Default hitbox size set to 25")
        gui:Destroy()
    end)

    -- Create button to set hitbox to 50
    local largeButton = Instance.new("TextButton")
    largeButton.Size = UDim2.new(0, 180, 0, 40)
    largeButton.Position = UDim2.new(0, 10, 0, 60)
    largeButton.Text = "Set Default Hitbox Size to 50"
    largeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    largeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    largeButton.Parent = frame
    largeButton.MouseButton1Click:Connect(function()
        _G.HeadSize = DEFAULT_HEAD_SIZE
        print("Default hitbox size set to 50")
        gui:Destroy()
    end)
end

-- Input Handling for Hotkeys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.H then
        _G.TeamHitboxSmall = not _G.TeamHitboxSmall
        print("Team members' hitbox size toggled.")
    elseif input.KeyCode == Enum.KeyCode.Y then
        _G.HeadSize = (_G.HeadSize == DEFAULT_HEAD_SIZE) and SMALL_HEAD_SIZE or DEFAULT_HEAD_SIZE
        print("Default hitbox size toggled to: " .. _G.HeadSize)
    elseif input.KeyCode == Enum.KeyCode.U then
        openHitboxSelectionMenu()
    elseif input.KeyCode == Enum.KeyCode.Z then
        -- Toggle hitbox size for team and normal players
        if _G.TeamHitboxSmall and _G.NormalPlayersSmall then
            _G.TeamHitboxSmall = false
            _G.NormalPlayersSmall = false
        elseif _G.TeamHitboxSmall and not _G.NormalPlayersSmall then
            _G.NormalPlayersSmall = true
        elseif not _G.TeamHitboxSmall and _G.NormalPlayersSmall then
            _G.TeamHitboxSmall = true
        else
            _G.TeamHitboxSmall = true
            _G.NormalPlayersSmall = true
        end
        print("Toggled hitbox size for team and normal players.")
    elseif input.KeyCode == Enum.KeyCode.I then
        _G.Disabled = not _G.Disabled
        print(_G.Disabled and "Hitbox adjustments disabled." or "Hitbox adjustments enabled.")
    end
end)

-- Adjust Hitboxes on Character Added
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        RunService.Heartbeat:Wait()
        adjustHitboxes()
    end)
end)

-- Adjust Hitboxes Periodically
RunService.Heartbeat:Connect(adjustHitboxes)

-- Initial Call
displayHitboxMenu()
