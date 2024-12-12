-- Specify your friends' usernames in the "Friends" table
local Friends = {"princessboss1233", "elleb4ackup123", "bblbbclove", "helpisneededo2", "iheartdogsxx2", "Sydneycraycray1240", "Venx900", "itsyouregirldemi55", "Billybobjrgaming7", "FirceGirl3"} -- Replace Friend1, Friend2 with your friends' usernames

_G.HeadSize = 50 -- Size for everyone else
_G.FriendHeadSize = 2 -- Smaller size for friends
_G.SmallHeadSize = 2 -- Size for normal players when Z is toggled
_G.Disabled = true
_G.FriendsHitboxSmall = true -- Toggle state for friends' hitbox size
_G.NormalPlayersSmall = false -- Toggle state for normal players' hitbox size

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- GitHub raw URL of the script
local ScriptURL = "https://raw.githubusercontent.com/affacakes/robloxscripts/main/hitboxexpander.lua" -- Replace with your GitHub raw URL

game:GetService('RunService').RenderStepped:Connect(function()
    if not _G.Disabled then return end

    for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
        if player.Name ~= game:GetService('Players').LocalPlayer.Name then
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
    end
end)