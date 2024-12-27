-- Specify your friends' usernames in the "Friends" table
local Friends = {"princessboss1233", "elleb4ackup123", "bblbbclove", "helpisneededo2", "iheartdogsxx2", "Sydneycraycray1240", "Venx900", "itsyouregirldemi55", "Billybobjrgaming7", "FirceGirl3", "vicky2010aa"} -- Replace Friend1, Friend2 with your friends' usernames

_G.HeadSize = 50 -- Size for everyone else
_G.FriendHeadSize = 2 -- Smaller size for friends
_G.SmallHeadSize = 2 -- Size for normal players when Z is toggled
_G.Disabled = true
_G.FriendsHitboxSmall = true -- Toggle state for friends' hitbox size
_G.NormalPlayersSmall = false -- Toggle state for normal players' hitbox size
_G.TeamHitboxSmall = false -- Toggle state for team members' hitbox size

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- GitHub raw URL of the script
local ScriptURL = "https://raw.githubusercontent.com/affacakes/robloxscripts/main/hitboxexpander.lua" -- Replace with your GitHub raw URL

local function updateHitbox(player, size, color)
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Check if a hitbox already exists
    local existingHitbox = humanoidRootPart:FindFirstChild("DummyHitbox")
    if not existingHitbox then
        -- Create a new dummy hitbox
        local hitbox = Instance.new("Part")
        hitbox.Name = "DummyHitbox"
        hitbox.Size = Vector3.new(size, size, size)
        hitbox.Transparency = 0.5
        hitbox.Anchored = true
        hitbox.CanCollide = false
        hitbox.BrickColor = BrickColor.new(color)
        hitbox.Material = Enum.Material.Neon
        hitbox.Parent = humanoidRootPart
    else
        -- Update existing hitbox
        existingHitbox.Size = Vector3.new(size, size, size)
        existingHitbox.BrickColor = BrickColor.new(color)
    end
end

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
    local screenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 0.4, 0)
    textLabel.Text = promptText
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.8, 0, 0.3, 0)
    textBox.Position = UDim2.new(0.1, 0, 0.5, 0)
    textBox.Text = ""
    textBox.TextColor3 = Color3.new(0, 0, 0)

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.4, 0, 0.3, 0)
    button.Position = UDim2.new(0.3, 0, 0.8, 0)
    button.Text = "Submit"

    button.MouseButton1Click:Connect(function()
        local input = textBox.Text
        if input ~= "" then
            callback(input)
        end
        screenGui:Destroy()
    end)
end

game:GetService('RunService').RenderStepped:Connect(function()
    if not _G.Disabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name ~= Players.LocalPlayer.Name then
            pcall(function()
                local size = _G.HeadSize
                local color = "Really blue"

                if table.find(Friends, player.Name) and _G.FriendsHitboxSmall then
                    size = _G.FriendHeadSize
                    color = "Lime green"
                elseif player.Team == Players.LocalPlayer.Team and _G.TeamHitboxSmall then
                    size = _G.FriendHeadSize
                    color = "New Yeller"
                elseif _G.NormalPlayersSmall then
                    size = _G.SmallHeadSize
                    color = "Really red"
                end

                updateHitbox(player, size, color)
            end)
        end
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
    elseif input.KeyCode == Enum.KeyCode.B then
        -- Add a friend menu
        displayMenu("Enter username to add as friend:", addFriend)
    elseif input.KeyCode == Enum.KeyCode.X then
        -- Remove a friend menu
        displayMenu("Enter username to remove from friends:", removeFriend)
    elseif input.KeyCode == Enum.KeyCode.H then
        -- Toggle team members' hitbox size
        _G.TeamHitboxSmall = not _G.TeamHitboxSmall
    elseif input.KeyCode == Enum.KeyCode.Y then
        if _G.HeadSize == 10 then
            _G.HeadSize = 50 -- Normal size
        else
            _G.HeadSize = 10
        end
        print("_G.HeadSize is now: " .. _G.HeadSize)
    end
end)
