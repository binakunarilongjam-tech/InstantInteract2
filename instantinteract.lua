local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// SETTINGS
local instantInteract = false
local iconLocked = false
local NORMAL_HOLD_DURATION = 1

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "InteractSettings"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

--// MAIN PANEL
local frame = Instance.new("Frame")
frame.Name = "MainPanel"
frame.Size = UDim2.fromOffset(240, 160)
frame.Position = UDim2.new(0.5, -120, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Interaction Settings"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

--// TOGGLE BUTTON
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(200, 40)
toggle.Position = UDim2.new(0.5, -100, 0, 45)
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.BorderSizePixel = 0
toggle.Text = "Instant Interact: OFF"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.TextSize = 15
toggle.Font = Enum.Font.GothamBold
toggle.AutoButtonColor = true
toggle.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle

--// LOCK BUTTON
local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.fromOffset(200, 32)
lockButton.Position = UDim2.new(0.5, -100, 0, 88)
lockButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
lockButton.BorderSizePixel = 0
lockButton.Text = "🔓  Icon Unlocked"
lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockButton.TextSize = 14
lockButton.Font = Enum.Font.GothamBold
lockButton.AutoButtonColor = true
lockButton.Parent = frame

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 8)
lockCorner.Parent = lockButton

--// CREDIT
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 25)
credit.Position = UDim2.new(0, 0, 1, -27)
credit.BackgroundTransparency = 1
credit.Text = "Made by MEXSUN_REHS3"
credit.TextColor3 = Color3.fromRGB(150, 150, 150)
credit.TextSize = 12
credit.Font = Enum.Font.Gotham
credit.Parent = frame

--// FLOATING FIRE ICON
local icon = Instance.new("TextButton")
icon.Name = "FloatingIcon"
icon.Size = UDim2.fromOffset(52, 52)
icon.Position = UDim2.fromOffset(18, 90)
icon.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
icon.BorderSizePixel = 0
icon.Text = "🔥"
icon.TextSize = 27
icon.Font = Enum.Font.GothamBold
icon.AutoButtonColor = true
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = icon

--// DRAG SYSTEM
local dragging = false
local dragStart
local startPosition
local moved = false

icon.InputBegan:Connect(function(input)
	if iconLocked then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		moved = false
		dragStart = input.Position
		startPosition = icon.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging or iconLocked then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
			moved = true
		end

		icon.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

--// OPEN / CLOSE GUI
icon.MouseButton1Click:Connect(function()
	if not moved then
		frame.Visible = not frame.Visible
	end
end)

--// APPLY INTERACTION MODE
local function updatePrompts()
	for _, object in ipairs(workspace:GetDescendants()) do
		if object:IsA("ProximityPrompt") then
			if instantInteract then
				object.HoldDuration = 0
			else
				object.HoldDuration = NORMAL_HOLD_DURATION
			end
		end
	end
end

--// TOGGLE INSTANT INTERACT
toggle.MouseButton1Click:Connect(function()
	instantInteract = not instantInteract

	if instantInteract then
		toggle.Text = "Instant Interact: ON"
		toggle.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
	else
		toggle.Text = "Instant Interact: OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end

	updatePrompts()
end)

--// LOCK / UNLOCK ICON
lockButton.MouseButton1Click:Connect(function()
	iconLocked = not iconLocked

	if iconLocked then
		lockButton.Text = "🔒  Icon Locked"
		lockButton.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
	else
		lockButton.Text = "🔓  Icon Unlocked"
		lockButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end
end)

--// APPLY TO NEW PROXIMITY PROMPTS
workspace.DescendantAdded:Connect(function(object)
	if object:IsA("ProximityPrompt") then
		if instantInteract then
			object.HoldDuration = 0
		else
			object.HoldDuration = NORMAL_HOLD_DURATION
		end
	end
end)

--// INITIAL UPDATE
updatePrompts()
