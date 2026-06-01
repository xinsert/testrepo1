local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MainUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- state
local isOpen = false

local settingsOpen = false
local savedTabs = {}
local miscItems = {} -- track misc buttons + header

-- blur
local Lighting = game:GetService("Lighting")

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- BUTTON
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 45, 0, 45)
button.Position = UDim2.new(1, -60, 0, 20)

button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
button.BackgroundTransparency = 0.35
button.Text = "S"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 22
button.Font = Enum.Font.GothamBold
button.Parent = gui

Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Transparency = 0.6
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Parent = button

-- MAIN FRAME
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 420)
main.Position = UDim2.new(0, 0, 0, 80)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Visible = false
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- TOP BAR
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 40)
topbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
topbar.Parent = main

Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 8)

-- fix bottom rounding
local fix = Instance.new("Frame")
fix.Size = UDim2.new(1, 0, 0, 10)
fix.Position = UDim2.new(0, 0, 1, -10)
fix.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
fix.BorderSizePixel = 0
fix.Parent = topbar

-- TITLE (LEFT)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)

title.BackgroundTransparency = 1
title.Text = "SilverV4"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

-- SETTINGS ICON (RIGHT)
local settings = Instance.new("TextButton")

settings.Size = UDim2.new(0, 30, 1, 0)
settings.Position = UDim2.new(1, -35, 0, 0)

settings.BackgroundTransparency = 1
settings.AutoButtonColor = false

settings.BackgroundTransparency = 1
settings.Text = "S"
settings.TextColor3 = Color3.fromRGB(160, 160, 160)
settings.TextSize = 18
settings.Font = Enum.Font.GothamBold
settings.TextXAlignment = Enum.TextXAlignment.Right
settings.Parent = topbar

-- SIDEBAR CONTAINER
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(1, 0, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundTransparency = 1
sidebar.Parent = main

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10) -- more spacing between items
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = sidebar

-- BUTTON CREATOR
local tabButtons = {}

local function createTab(name)
	local b = Instance.new("TextButton")

	b.Size = UDim2.new(1, -30, 0, 24)
	b.BackgroundTransparency = 1

	b.Text = name
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.TextSize = 14
	b.Font = Enum.Font.Gotham
	b.TextXAlignment = Enum.TextXAlignment.Left

	b.Parent = sidebar

	table.insert(savedTabs, b)

	tabButtons[name] = b

	return b
end

-- CREATE TAB FRAME

local function CreateTabFrame(name)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 180, 0, 30) -- only header height
	frame.Position = UDim2.new(0, 220, 0, 80)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.Visible = false -- start hidden
	frame.Parent = gui

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 30)
	header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	header.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -30, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 20, 0, 20)
	toggle.Position = UDim2.new(1, -25, 0, 5)
	toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Text = ""
	toggle.Parent = header

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 0, 0) -- empty, height 0
	content.Position = UDim2.new(0, 0, 0, 30)
	content.BackgroundTransparency = 1
	content.Parent = frame
	content.Visible = false

	-- toggle behavior
	toggle.MouseButton1Click:Connect(function()
		content.Visible = not content.Visible
		toggle.BackgroundColor3 = content.Visible and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,100)
	end)

	return {
		Frame = frame,
		Header = header,
		Content = content,
		Toggle = toggle
	}
end

-- TABS
createTab("Combat")
createTab("Blatant")
createTab("World")
createTab("Render")
createTab("Inventory")
createTab("Automatic")
createTab("Other")

local CombatFrame = CreateTabFrame("Combat")

tabButtons["Combat"].MouseButton1Click:Connect(function()
	CombatFrame.Frame.Visible = not CombatFrame.Frame.Visible
end)

-- SEPARATOR HEADER
local miscHeader = Instance.new("Frame")
miscHeader.Size = UDim2.new(1, 0, 0, 30)
miscHeader.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
miscHeader.BorderSizePixel = 0
miscHeader.Parent = sidebar
table.insert(miscItems, miscHeader)

local miscCorner = Instance.new("UICorner")
miscCorner.CornerRadius = UDim.new(0, 6)
miscCorner.Parent = miscHeader

local miscText = Instance.new("TextLabel")
miscText.Size = UDim2.new(1, -20, 1, 0)
miscText.Position = UDim2.new(0, 10, 0, 0)

miscText.BackgroundTransparency = 1
miscText.Text = "MISC"
miscText.TextColor3 = Color3.fromRGB(255, 255, 255)
miscText.TextSize = 16
miscText.Font = Enum.Font.GothamBold
miscText.TextXAlignment = Enum.TextXAlignment.Left
miscText.Parent = miscHeader

-- MISC BUTTON CREATOR
local function createMiscButton(name, callback)
    local b = Instance.new("TextButton")

    b.Size = UDim2.new(1, -30, 0, 24)
    b.BackgroundTransparency = 1

    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left

    b.Parent = sidebar

    -- ✅ add this line so it hides with settings
    table.insert(miscItems, b)

    if callback then
        b.MouseButton1Click:Connect(callback)
    end

    return b
end

-- SELF DESTRUCT

local function selfDestruct()
	-- turn off blur FIRST
	if blur then
		blur:Destroy()
	end

	-- destroy GUI
	if gui then
		gui:Destroy()
	end

	-- optional safety cleanup (helps stop leftover loops/connections if you add them later)
	isOpen = false
end

-- MISC BUTTONS
createMiscButton("Profiles", function()
	print("Profiles clicked")
end)

createMiscButton("Self Destruct", function()
	selfDestruct()
end)

-- SETTINGS TOGGLE

local function openSettings()
	settingsOpen = true
	settings.TextColor3 = Color3.fromRGB(255, 255, 255)

	for _, tab in ipairs(savedTabs) do
		tab.Visible = false
	end

	for _, item in ipairs(miscItems) do
		item.Visible = false
	end
end

local function closeSettings()
	settingsOpen = false
	settings.TextColor3 = Color3.fromRGB(160, 160, 160)

	for _, tab in ipairs(savedTabs) do
		tab.Visible = true
	end

	for _, item in ipairs(miscItems) do
		item.Visible = true
	end
end

settings.MouseButton1Click:Connect(function()
	if settingsOpen then
		closeSettings()
	else
		openSettings()
	end
end)

-- BLUR TOGGLE
button.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	main.Visible = isOpen
	blur.Size = isOpen and 10 or 0
end)

--DRAGGABILITY
local UIS = game:GetService("UserInputService")

topbar.Active = true
topbar.Selectable = true

local dragging = false
local dragStart
local startPos
local dragInput

topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = main.Position
		dragInput = input
	end
end)

topbar.InputEnded:Connect(function(input)
	if input == dragInput then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then

		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
