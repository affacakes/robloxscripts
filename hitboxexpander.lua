-- Specify your friends' usernames in the "Friends" table
local Friends = {"princessboss1233", "elleb4ackup123", "bblbbclove", "helpisneededo2", "iheartdogsxx2", "Sydneycraycray1240", "Venx900", "itsyouregirldemi55", "Billybobjrgaming7", "FirceGirl3", "vicky2010aa"}

_G.HeadSize = 50 -- Size for everyone else
_G.FriendHeadSize = 2 -- Smaller size for friends
_G.SmallHeadSize = 2 -- Size for normal players when Z is toggled
_G.Disabled = true
_G.FriendsHitboxSmall = true -- Toggle state for friends' hitbox size
_G.NormalPlayersSmall = false -- Toggle state for normal players' hitbox size

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

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

-- Function to display a menu for input
local function displayMenu(promptText, callback)
    -- Close any existing menus before opening a new one
    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("FriendMenu") then
        game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("FriendMenu"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "FriendMenu"
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderRadius = UDim.new(0, 10)

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 0.4, 0)
    textLabel.Text = promptText
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1

    local dropdown = Instance.new("TextButton", frame)
    dropdown.Size = UDim2.new(0.8, 0, 0.3, 0)
    dropdown.Position = UDim2.new(0.1, 0, 0.5, 0)
    dropdown.Text = "Select a player"
    dropdown.TextColor3 = Color3.new(0, 0, 0)
    dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.4, 0, 0.3, 0)
    submitButton.Position = UDim2.new(0.3, 0, 0.8, 0)
    submitButton.Text = "Submit"
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    submitButton.Visible = false -- Hide the submit button initially

    -- Populate dropdown with player names
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name ~= Players.LocalPlayer.Name then
            table.insert(playerNames, player.Name .. " (" .. (player.DisplayName or "No Display Name") .. ")")
        end
    end

    -- Create dropdown options
    for _, playerName in ipairs(playerNames) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 30)
        button.Text = playerName
        button.TextColor3 = Color3.new(0, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        button.Parent = frame

        button.MouseButton1Click:Connect(function()
            dropdown.Text = playerName
            submitButton.Visible = true -- Show the submit button when a player is selected
        end)
    end

    -- Close button
    local closeButton = Instance.new("TextButton", frame)
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    submitButton.MouseButton1Click:Connect(function()
        local selectedPlayerName = dropdown.Text
        if selectedPlayerName ~= "Select a player" then
            local username = selectedPlayerName:split(" ")[1]
            if table.find(Friends, username) then
                removeFriend(username)
                print(username .. " has been removed from the friends list.")
            else
                addFriend(username)
                print(username .. " has been added to the friends list.")
            end
            screenGui:Destroy()
        end
    end)
end

game:GetService('RunService').RenderStepped:Connect(function()
    if not _G.Disabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name ~= Players.LocalPlayer.Name then
            pcall(function()
                local character = player.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    if table.find(Friends, player.Name) then
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
        end
    end
end)

-- Disable key toggles when typing in the chat
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Chat") then
        _G.Disabled = true
    else
        _G.Disabled = false
    end
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
        displayMenu("Select a player to add as friend:", addFriend)
    elseif input.KeyCode == Enum.KeyCode.X then
        -- Remove a friend menu
        displayMenu("Select a player to remove from friends:", removeFriend)
    end
end)
