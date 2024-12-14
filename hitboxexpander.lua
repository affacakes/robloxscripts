local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local friends = {"princessboss1233", "elleb4ackup123", "bblbbclove", "helpisneededo2", "iheartdogsxx2", "Sydneycraycray1240", "Venx900", "itsyouregirldemi55", "Billybobjrgaming7", "FirceGirl3", "vicky2010aa"}
local GUIsOpen = {Add = false, Remove = false}
local flightEnabled = true

local function createGUI(name, placeholderText, buttonText)
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.3, 0, 0.2, 0)
    frame.Position = UDim2.new(0.35, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.8, 0, 0.3, 0)
    textBox.Position = UDim2.new(0.1, 0, 0.2, 0)
    textBox.PlaceholderText = placeholderText
    textBox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
    textBox.Text = ""
    textBox.TextColor3 = Color3.new(0, 0, 0)
    textBox.Parent = frame

    local textCorner = Instance.new("UICorner")
    textCorner.CornerRadius = UDim.new(0, 5)
    textCorner.Parent = textBox

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.4, 0, 0.2, 0)
    button.Position = UDim2.new(0.3, 0, 0.6, 0)
    button.Text = buttonText
    button.BackgroundColor3 = Color3.new(0.1, 0.7, 0.1)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.9, -20, 0, 10)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Parent = frame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton

    return gui, frame, textBox, button, closeButton
end

local addGUI, addFrame, addTextBox, addButton, addCloseButton = createGUI("AddFriendGUI", "Enter username...", "Add")
local removeGUI, removeFrame, removeTextBox, removeButton, removeCloseButton = createGUI("RemoveFriendGUI", "Enter username...", "Remove")

addGUI.Enabled = false
removeGUI.Enabled = false

local function toggleGUI(gui, otherGUI)
    if gui.Enabled then
        gui.Enabled = false
    else
        otherGUI.Enabled = false
        gui.Enabled = true
    end
end

addButton.MouseButton1Click:Connect(function()
    local username = addTextBox.Text
    if username ~= "" and not table.find(friends, username) then
        table.insert(friends, username)
        print(username .. " added to friends list.")
    end
end)

removeButton.MouseButton1Click:Connect(function()
    local username = removeTextBox.Text
    if username ~= "" then
        for i, friend in ipairs(friends) do
            if friend == username then
                table.remove(friends, i)
                print(username .. " removed from friends list.")
                break
            end
        end
    end
end)

addCloseButton.MouseButton1Click:Connect(function()
    addGUI.Enabled = false
end)

removeCloseButton.MouseButton1Click:Connect(function()
    removeGUI.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.V then
        toggleGUI(addGUI, removeGUI)
    elseif input.KeyCode == Enum.KeyCode.X then
        toggleGUI(removeGUI, addGUI)
    end
end)

local typingInChatOrGUI = false

local function onTextBoxFocused()
    typingInChatOrGUI = true
end

local function onTextBoxFocusLost()
    typingInChatOrGUI = false
end

addTextBox.Focused:Connect(onTextBoxFocused)
addTextBox.FocusLost:Connect(onTextBoxFocusLost)
removeTextBox.Focused:Connect(onTextBoxFocused)
removeTextBox.FocusLost:Connect(onTextBoxFocusLost)

UserInputService.TextBoxFocused:Connect(function()
    typingInChatOrGUI = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    typingInChatOrGUI = false
end)

RunService.RenderStepped:Connect(function()
    if not typingInChatOrGUI then
        -- Flight or other keybind logic goes here
    end
end)
