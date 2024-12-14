-- Variables for flying
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart
local humanoid
local flying = false
local speed = 70
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local bg, bv

-- Noclip variables
local Noclip = nil
local Clip = nil

-- Functions for flying
local function Fly()
    if flying then
        bg = Instance.new("BodyGyro", humanoidRootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = humanoidRootPart.CFrame
        bv = Instance.new("BodyVelocity", humanoidRootPart)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.velocity = Vector3.new(0, 0.1, 0)
    end
end

local function StopFlying()
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    flying = false
    if humanoid then
        humanoid.PlatformStand = false
    end
end

local function UpdateMovement()
    if flying then
        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + 
            ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
        bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / 1000), 0, 0)
    end
end

-- Functions for noclip
local function noclip()
    Clip = false
    local function Nocl()
        if Clip == false and player.Character ~= nil then
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA('BasePart') and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
        wait(0.21) -- basic optimization
    end
    Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
end

local function clip()
    if Noclip then Noclip:Disconnect() end
    Clip = true
end

-- Handle key presses
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Q then
            flying = not flying
            if flying then
                humanoid.PlatformStand = true
                Fly()
                noclip() -- Enable noclip when flying
            else
                StopFlying()
                clip() -- Disable noclip when not flying
            end
        elseif input.KeyCode == Enum.KeyCode.W then
            ctrl.f = 1
        elseif input.KeyCode == Enum.KeyCode.S then
            ctrl.b = -1
        elseif input.KeyCode == Enum.KeyCode.A then
            ctrl.l = -1
        elseif input.KeyCode == Enum.KeyCode.D then
            ctrl.r = 1
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then
            ctrl.f = 0
        elseif input.KeyCode == Enum.KeyCode.S then
            ctrl.b = 0
        elseif input.KeyCode == Enum.KeyCode.A then
            ctrl.l = 0
        elseif input.KeyCode == Enum.KeyCode.D then
            ctrl.r = 0
        end
    end
end)

-- Update movement in game loop
game:GetService("RunService").Heartbeat:Connect(function()
    UpdateMovement()
end)

-- Handle character respawn
local function OnCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    StopFlying() -- Reset flying state
    clip() -- Reset noclip state
end

player.CharacterAdded:Connect(OnCharacterAdded)

-- Initialize on script load
OnCharacterAdded(character)
