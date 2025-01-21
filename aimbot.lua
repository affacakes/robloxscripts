--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

--// Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Environment = {}

--// Default Settings
Environment.Settings = {
    ThirdPersonSensitivity = 3,
    ReloadOnTeleport = true,
    Enabled = true,
    Sensitivity = 0,
    SendNotifications = true,
    WallCheck = false,
    TriggerKey = "MouseButton2",
    SaveSettings = true,
    AliveCheck = true,
    ThirdPerson = false,
    LockPart = "Head",
    TeamCheck = false,
    Toggle = false,
    Volume = 50 -- Added slider value for volume
}

--// Create GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Settings = {} -- Stores the GUI elements for each setting

ScreenGui.Name = "AimbotSettingsGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

Frame.Name = "SettingsFrame"
Frame.Size = UDim2.new(0, 300, 0, 450)  -- Adjusted size for extra controls
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Aimbot Settings"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

-- Helper function for clamping values (for the slider)
function math.clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

-- Button class (Extends Element)
Button = {}
Button.__index = Button

function Button:new(x, y, width, height, r, g, b, alpha, text, font, size)
    local self = setmetatable({}, Button)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.r = r
    self.g = g
    self.b = b
    self.alpha = alpha
    self.text = text
    self.font = font or "Arial"
    self.size = size or 14
    return self
end

function Button:draw()
    -- Draw the element using basic properties
    love.graphics.setColor(self.r, self.g, self.b, self.alpha)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.setFont(love.graphics.newFont(self.font, self.size))
    love.graphics.printf(self.text, self.x, self.y + self.height / 2 - self.size / 2, self.width, "center")
end

function Button:mouseClick()
    local mx, my = love.mouse.getPosition()
    return mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height
end

function Button:clickAction()
    print(self.text .. " clicked")
end

-- Create Setting function (used for buttons, sliders, etc.)
local function createSetting(name, value)
    local SettingFrame = Instance.new("Frame")
    local SettingLabel = Instance.new("TextLabel")
    local SettingInput

    SettingFrame.Size = UDim2.new(1, -20, 0, 40)
    SettingFrame.Position = UDim2.new(0, 10, 0, #Settings * 50 + 60)
    SettingFrame.BackgroundTransparency = 1
    SettingFrame.Parent = Frame

    SettingLabel.Size = UDim2.new(0.6, 0, 1, 0)
    SettingLabel.BackgroundTransparency = 1
    SettingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingLabel.Text = name
    SettingLabel.Font = Enum.Font.SourceSans
    SettingLabel.TextSize = 18
    SettingLabel.Parent = SettingFrame

    if type(value) == "boolean" then
        SettingInput = Instance.new("TextButton")
        SettingInput.Text = tostring(value)
        SettingInput.MouseButton1Click:Connect(function()
            Environment.Settings[name] = not Environment.Settings[name]
            SettingInput.Text = tostring(Environment.Settings[name])
        end)
    elseif type(value) == "number" then
        SettingInput = Instance.new("TextBox")
        SettingInput.Text = tostring(value)
        SettingInput.FocusLost:Connect(function()
            local input = tonumber(SettingInput.Text)
            if input then
                Environment.Settings[name] = input
            end
            SettingInput.Text = tostring(Environment.Settings[name])
        end)
    elseif type(value) == "string" then
        SettingInput = Instance.new("TextBox")
        SettingInput.Text = value
        SettingInput.FocusLost:Connect(function()
            Environment.Settings[name] = SettingInput.Text
        end)
    end

    SettingInput.Size = UDim2.new(0.4, 0, 1, 0)
    SettingInput.Position = UDim2.new(0.6, 0, 0, 0)
    SettingInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SettingInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingInput.Font = Enum.Font.SourceSans
    SettingInput.TextSize = 18
    SettingInput.Parent = SettingFrame

    Settings[name] = SettingInput
end

-- Initialize GUI with Settings
for name, value in pairs(Environment.Settings) do
    createSetting(name, value)
end

-- Notification Function
local function notify(message)
    if Environment.Settings.SendNotifications then
        StarterGui:SetCore("SendNotification", {
            Title = "Aimbot",
            Text = message,
            Duration = 3
        })
    end
end

-- Save Settings (Optional)
local function saveSettings()
    if Environment.Settings.SaveSettings then
        writefile("AimbotSettings.json", game:GetService("HttpService"):JSONEncode(Environment.Settings))
    end
end

local function loadSettings()
    if isfile("AimbotSettings.json") then
        local data = readfile("AimbotSettings.json")
        Environment.Settings = game:GetService("HttpService"):JSONDecode(data)
    end
end

-- Load and Save Settings
loadSettings()
notify("Aimbot GUI Loaded")
