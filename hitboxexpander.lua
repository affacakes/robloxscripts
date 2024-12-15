-- Specify your friends' usernames in the "Friends" table
local Friends = {"princessboss1233", "elleb4ackup123", "bblbbclove", "helpisneededo2", "iheartdogsxx2", "Sydneycraycray1240", "Venx900", "itsyouregirldemi55", "Billybobjrgaming7", "FirceGirl3", "vicky2010aa"}

_G.HeadSize = 50 -- Size for everyone else
_G.FriendHeadSize = 2 -- Smaller size for friends
_G.SmallHeadSize = 2 -- Size for normal players when Z is toggled
_G.Disabled = true
_G.TeamHitboxSmall = false -- Toggle for reducing team members' hitboxes

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

game:GetService('RunService').RenderStepped:Connect(function()
    if not _G.Disabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name ~= LocalPlayer.Name then
            pcall(function()
                local character = player.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    if table.find(Friends, player.Name) then
                        -- Adjust hitbox for friends
                        humanoidRootPart.Size = Vector3.new(_G.FriendHeadSize, _G.FriendHeadSize, _G.FriendHeadSize)
                        humanoidRootPart.Transparency = 0.3
                        humanoidRootPart.BrickColor = BrickColor.new("Lime green")
                        humanoidRootPart.Material = "SmoothPlastic"
                    elseif player.Team == LocalPlayer.Team and _G.TeamHitboxSmall then
                        -- Adjust hitbox for team members
                        humanoidRootPart.Size = Vector3.new(_G.FriendHeadSize, _G.FriendHeadSize, _G.FriendHeadSize)
                        humanoidRootPart.Transparency = 0.5
                        humanoidRootPart.BrickColor = BrickColor.new("Bright yellow")
                        humanoidRootPart.Material = "SmoothPlastic"
                    else
                        -- Normal hitbox for others
                        humanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        humanoidRootPart.Transparency = 0.7
                        humanoidRootPart.BrickColor = BrickColor.new("Really blue")
                        humanoidRootPart.Material = "Neon"
                    end
                    humanoidRootPart.CanCollide = false
                end
            end)
        end
    end
end)

-- Toggle team hitbox size on H key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        _G.TeamHitboxSmall = not _G.TeamHitboxSmall
    elseif input.KeyCode == Enum.KeyCode.T then
        _G.FriendsHitboxSmall = not _G.FriendsHitboxSmall
    elseif input.KeyCode == Enum.KeyCode.C then
        -- Check for updates and reload script
        local HttpService = game:GetService("HttpService")
        local ScriptURL = "https://raw.githubusercontent.com/affacakes/robloxscripts/main/hitboxexpander.lua"
        pcall(function()
            local newScript = HttpService:GetAsync(ScriptURL)
            if newScript and newScript ~= script.Source then
                loadstring(newScript)()
            end
        end)
    end
end)
