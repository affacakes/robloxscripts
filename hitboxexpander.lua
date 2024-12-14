local Friends = {"princessboss1233", "elleb4ackup123", "bblbbclove", "helpisneededo2", "iheartdogsxx2", "Sydneycraycray1240", "Venx900", "itsyouregirldemi55", "Billybobjrgaming7", "FirceGirl3", "vicky2010aa"} -- Replace Friend1, Friend2 with your friends' usernames

_G.HeadSize = 50 -- Size for everyone else
_G.FriendHeadSize = 2 -- Smaller size for friends
_G.SmallHeadSize = 2 -- Size for normal players when Z is toggled
_G.Disabled = true
_G.FriendsHitboxSmall = true -- Toggle state for friends' hitbox size
_G.NormalPlayersSmall = false -- Toggle state for normal players' hitbox size

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GitHub raw URL of the script
local ScriptURL = "https://raw.githubusercontent.com/affacakes/robloxscripts/main/hitboxexpander.lua" -- Replace with your GitHub raw URL

-- Function to add a friend
local function addFriend(username)
    if not table.find(Friends, username) then
        table.insert(Friends, username)
        print(username .. " has been added to the friends list.")
    else
        print(username .. " is already in the friends list.")
    end
end

-- Function to remove a friend
local function removeFriend(username)
    local index = table.find(Friends, username)
    if index then
        table.remove(Friends, index)
        print(username .. " has been removed from the friends list.")
    else
        print(username .. " is not in the friends list.")
    end
end

-- Function to create the dropdown menu and show available players
local function createDropdownMenu(frame)
    local dropdown = Instance.new("TextButton", frame)
    dropdown.Size = UDim2.new(0.8, 0, 0.3, 0)
    dropdown.Position = UDim2.new(0.1, 0, 0.5, 0)
    dropdown.Text = "Select Player"
    dropdown.TextColor3 = Color3.new(1, 1, 1)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdown.TextButtonMode = Enum.ButtonMode.Toggle

    local function updateDropdown()
        dropdown.Text = "Select Player (Update)"
        local playersList = ""
        for _, player in ipairs(Players:GetPlayers()) do
            playersList = playersList .. player.Name .. " (" .. player.DisplayName .. ")\n"
        end
        dropdown.Text = playersList
    end

    updateDropdown()
    Players.PlayerAdded:Connect(updateDropdown)

    return dropdown
end

-- Function to display a menu for input
local function displayMenu(promptText, callback)
    local screenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderRadius = UDim.new(0, 10)  -- Round corners

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 0.4, 0)
    textLabel.Text = promptText
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1

    local playerDropdown = createDropdownMenu(frame)

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.4, 0, 0.3, 0)
    button.Position = UDim2.new(0.3, 0, 0.8, 0)
    button.Text = "Submit"
    button.Visible = false

    -- Show the submit button when a username is selected from the dropdown
    playerDropdown.MouseButton1Click:Connect(function()
        button.Visible = true
    end)

    button.MouseButton1Click:Connect(function()
        local playerName = playerDropdown.Text:match("^(.-)%s*%(") -- Extract the name part before parentheses
        if playerName and playerName ~= "" then
            callback(playerName)
        end
        screenGui:Destroy()
    end)
end

game:GetService('RunService').RenderStepped:Connect(function()
    if not _G.Disabled then return end

    -- Apply changes only to your character
    local character = Players.LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        -- Apply health bar visibility for everyone, but only you will see it
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- Force health bar display for everyone
                    humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.Bar
                end
            end
        end

        -- Position bubble chat above head for all players, but only you will see the changes
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local bubbleChat = player.Character:FindFirstChild("BubbleChat")
                if bubbleChat then
                    bubbleChat.Position = head.Position + Vector3.new(0, 2, 0)  -- Adjust position as needed
                end
            end
        end

        -- Adjust your hitbox
        if table.find(Friends, Players.LocalPlayer.Name) then
            -- Adjust hitbox for friends based on toggle state
            if _G.FriendsHitboxSmall then
                humanoidRootPart.Size = Vector3.new(_G.FriendHeadSize, _G.FriendHeadSize, _G.FriendHeadSize)
                humanoidRootPart.Transparency = 0.3
                humanoidRootPart.BrickColor = BrickColor.new("Lime green")
                humanoidRootPart.Material = "SmoothPlastic"
            else
                humanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                humanoidRootPart.Transparency = 0.7
                humanoidRootPart.BrickColor = BrickColor.new("Really blue")
                humanoidRootPart.Material = "Neon"
            end
        else
            -- Adjust hitbox for normal players based on Z toggle state
            if _G.NormalPlayersSmall then
                humanoidRootPart.Size = Vector3.new(_G.SmallHeadSize, _G.SmallHeadSize, _G.SmallHeadSize)
                humanoidRootPart.Transparency = 0.3
                humanoidRootPart.BrickColor = BrickColor.new("Really red")
                humanoidRootPart.Material = "SmoothPlastic"
            else
                humanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                humanoidRootPart.Transparency = 0.7
                humanoidRootPart.BrickColor = BrickColor.new("Really blue")
                humanoidRootPart.Material = "Neon"
            end
        end
        humanoidRootPart.CanCollide = false
    end
end)

-- Toggle friends' hitbox size on T key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T then
        _G.FriendsHitboxSmall = not _G.FriendsHitboxSmall
    elseif input.KeyCode == Enum.KeyCode.C then
        -- Check for updates and reload script
        pcall(function()
            local newScript = HttpService:GetAsync(ScriptURL)
            if newScript and newScript ~= script.Source then
                loadstring(newScript)()
            end
        end)
    elseif input.KeyCode == Enum.KeyCode.Z then
        -- Toggle normal players' hitbox size
        _G.NormalPlayersSmall = not _G.NormalPlayersSmall
    elseif input.KeyCode == Enum.KeyCode.V then
        -- Add a friend menu
        displayMenu("Enter username to add as friend:", addFriend)
    elseif input.KeyCode == Enum.KeyCode.X then
        -- Remove a friend menu
        displayMenu("Enter username to remove from friends:", removeFriend)
    end
end)
