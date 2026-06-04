local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MainUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- state
local isOpen = false
local settingsOpen = false
local savedTabs = {}
local miscItems = {}
local tabFrames = {}
local tabFramesByName = {}

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
button.TextColor3 = Color3.fromRGB(255,255,255)
button.TextSize = 22
button.Font = Enum.Font.GothamBold
button.Parent = gui
Instance.new("UICorner", button).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Transparency = 0.6
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Parent = button

-- MAIN FRAME
local main = Instance.new("Frame")
main.Size = UDim2.new(0,200,0,420)
main.Position = UDim2.new(0,0,0,80)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)

-- TOPBAR
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1,0,0,40)
topbar.BackgroundColor3 = Color3.fromRGB(18,18,18)
topbar.Parent = main
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0,8)

-- fix bottom rounding
local fix = Instance.new("Frame")
fix.Size = UDim2.new(1,0,0,10)
fix.Position = UDim2.new(0,0,1,-10)
fix.BackgroundColor3 = Color3.fromRGB(18,18,18)
fix.BorderSizePixel = 0
fix.Parent = topbar

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "SilverV4"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

-- SETTINGS ICON
local settings = Instance.new("TextButton")
settings.Size = UDim2.new(0,30,1,0)
settings.Position = UDim2.new(1,-35,0,0)
settings.BackgroundTransparency = 1
settings.AutoButtonColor = false
settings.Text = "S"
settings.TextColor3 = Color3.fromRGB(160,160,160)
settings.TextSize = 18
settings.Font = Enum.Font.GothamBold
settings.TextXAlignment = Enum.TextXAlignment.Right
settings.Parent = topbar

-- SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(1,0,1,-40)
sidebar.Position = UDim2.new(0,0,0,40)
sidebar.BackgroundTransparency = 1
sidebar.Parent = main

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = sidebar

-- TAB BUTTON CREATOR
local tabButtons = {}
local function createTab(name)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-30,0,24)
	b.BackgroundTransparency = 1
	b.Text = name
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.TextSize = 14
	b.Font = Enum.Font.Gotham
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.Parent = sidebar
	table.insert(savedTabs,b)
	tabButtons[name] = b
	return b
end

-- TAB FRAME CREATOR
local function CreateTabFrame(name)
	local expanded = false
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,180,0,30)
	frame.Position = UDim2.new(0,220,0,80)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.Visible = false
	frame.Parent = gui

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1,0,0,30)
	header.BackgroundColor3 = Color3.fromRGB(25,25,25)
	header.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,-30,1,0)
	title.Position = UDim2.new(0,10,0,0)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0,20,0,20)
	toggle.Position = UDim2.new(1,-25,0,5)
	toggle.BackgroundColor3 = Color3.fromRGB(180,180,180)
	toggle.Text = ""
	toggle.Parent = header

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,0,0,0)
	content.Position = UDim2.new(0,0,0,30)
	content.BackgroundTransparency = 1
	content.Visible = false
	content.Parent = frame

	local contentList = Instance.new("UIListLayout")
	contentList.Padding = UDim.new(0,2)
	contentList.SortOrder = Enum.SortOrder.LayoutOrder
	contentList.Parent = content

	local contentList = Instance.new("UIListLayout")
	contentList.Padding = UDim.new(0,2)
	contentList.SortOrder = Enum.SortOrder.LayoutOrder
	contentList.Parent = content

	contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.Size = UDim2.new(
			1,
			0,
			0,
			contentList.AbsoluteContentSize.Y
		)

		frame.Size = UDim2.new(
			0,
			180,
			0,
			30 + contentList.AbsoluteContentSize.Y
		)
	end)

	toggle.MouseButton1Click:Connect(function()
		expanded = not expanded
		content.Visible = expanded

		toggle.BackgroundColor3 =
			expanded and Color3.fromRGB(255,255,255)
			or Color3.fromRGB(180,180,180)
	end)

	-- draggable header
	local UIS = game:GetService("UserInputService")
	local dragging, dragStart, startPos, dragInput = false

	header.Active = true
	header.Selectable = true
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			dragInput = input
		end
	end)
	header.InputEnded:Connect(function(input)
		if input == dragInput then dragging = false end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
		end
	end)

	local tabData = {Name=name,Frame=frame,Toggle=toggle,Content=content,Open=false}
	table.insert(tabFrames,tabData)
	tabFramesByName[name] = tabData
	return tabData
end

-- CREATE TABS
createTab("Combat")
createTab("Blatant")
createTab("World")
createTab("Render")
createTab("Inventory")
createTab("Automatic")
createTab("Other")

-- CREATE TAB FRAMES
for _, tabName in ipairs({
	"Combat",
	"Blatant",
	"World",
	"Render",
	"Inventory",
	"Automatic",
	"Other"
}) do
	CreateTabFrame(tabName)
end

-- UNIVERSAL TAB CLICK LOGIC
for name, button in pairs(tabButtons) do
	button.MouseButton1Click:Connect(function()
		local tab = tabFramesByName[name]
		if not tab then
			return
		end

		-- toggle this tab only
		tab.Open = not tab.Open

		tab.Frame.Visible = tab.Open
		tab.Content.Visible = tab.Open

		if tab.Open then
			tab.Toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
		else
			tab.Toggle.BackgroundColor3 = Color3.fromRGB(180,180,180)
		end
	end)
end
-- MISC HEADER
local miscHeader = Instance.new("Frame")
miscHeader.Size = UDim2.new(1,0,0,30)
miscHeader.BackgroundColor3 = Color3.fromRGB(18,18,18)
miscHeader.BorderSizePixel = 0
miscHeader.Parent = sidebar
table.insert(miscItems,miscHeader)

local miscCorner = Instance.new("UICorner")
miscCorner.CornerRadius = UDim.new(0,6)
miscCorner.Parent = miscHeader

local miscText = Instance.new("TextLabel")
miscText.Size = UDim2.new(1,-20,1,0)
miscText.Position = UDim2.new(0,10,0,0)
miscText.BackgroundTransparency = 1
miscText.Text = "MISC"
miscText.TextColor3 = Color3.fromRGB(255,255,255)
miscText.TextSize = 16
miscText.Font = Enum.Font.GothamBold
miscText.TextXAlignment = Enum.TextXAlignment.Left
miscText.Parent = miscHeader

-- MISC BUTTON CREATOR
local function createMiscButton(name, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-30,0,24)
	b.BackgroundTransparency = 1
	b.Text = name
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.TextSize = 14
	b.Font = Enum.Font.Gotham
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.Parent = sidebar

	table.insert(miscItems, b)

	if callback then
		b.MouseButton1Click:Connect(callback)
	end

	return b
end

-- SORT GUI BUTTON
createMiscButton("Sort GUI", function()
	local startX = 220
	local startY = 80
	local spacing = 200
	local rowSpacing = 300 -- vertical spacing for next row
	local maxPerRow = 5   -- put 5 tabs per row

	for i, tab in ipairs(tabFrames) do
		local row = math.floor((i-1)/maxPerRow)
		local col = (i-1) % maxPerRow
		tab.Frame.Position = UDim2.new(0, startX + col*spacing, 0, startY + row*rowSpacing)
		tab.Frame.Visible = true
		tab.Content.Visible = tab.Open
		tab.Toggle.BackgroundColor3 = tab.Open and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,180)
	end
end)

-- SELF DESTRUCT
local function selfDestruct()
	if blur then blur:Destroy() end
	if gui then gui:Destroy() end
	isOpen = false
end

-- MODULES

local modules = {}

local moduleContainer = Instance.new("Frame")
moduleContainer.Size = UDim2.new(1, -10, 1, -50)
moduleContainer.Position = UDim2.new(0, 5, 0, 40)
moduleContainer.BackgroundTransparency = 1
moduleContainer.Parent = sidebar

local moduleList = Instance.new("UIListLayout")
moduleList.Padding = UDim.new(0, 2)
moduleList.SortOrder = Enum.SortOrder.LayoutOrder
moduleList.Parent = moduleContainer

-- MISC BUTTONS
createMiscButton("Profiles", function()
	print("Profiles clicked")
end)

createMiscButton("Self Destruct", function()
	selfDestruct()
end)

-- SETTINGS
local function openSettings()
	settingsOpen = true
	settings.TextColor3 = Color3.fromRGB(255,255,255)

	for _, tab in ipairs(savedTabs) do
		tab.Visible = false
	end

	for _, item in ipairs(miscItems) do
		item.Visible = false
	end
end

local function closeSettings()
	settingsOpen = false
	settings.TextColor3 = Color3.fromRGB(160,160,160)

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

-- MAIN TOGGLE (blur + GUI)
button.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	main.Visible = isOpen
	blur.Size = isOpen and 10 or 0

	if isOpen then
		-- restore tabs exactly how they were
		for _, tab in ipairs(tabFrames) do
			tab.Frame.Visible = tab.Open
			tab.Content.Visible = tab.Open

			tab.Toggle.BackgroundColor3 =
				tab.Open
				and Color3.fromRGB(255,255,255)
				or Color3.fromRGB(180,180,180)
		end
	else
		-- temporarily hide everything
		for _, tab in ipairs(tabFrames) do
			tab.Frame.Visible = false
			tab.Content.Visible = false
		end
	end
end)

-- DRAG MAIN GUI
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











-- MODULE FUNCTION (CAN BE MOVED LATER)

local function CreateModule(data)
	local module = {
		Name = data.Name,
		Tooltip = data.Tooltip or "No info",
		Enabled = false,
		Mode = data.Mode or "Toggle", -- Toggle / Button
		Callback = data.Callback or function() end
	}

	local row = Instance.new("TextButton")
	row.Text = ""
	row.AutoButtonColor = false
	row.Size = UDim2.new(1, 0, 0, 28)
	row.BackgroundColor3 = Color3.fromRGB(25,25,25)
	row.BorderSizePixel = 0
	row.Parent = tab.Content

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = Color3.fromRGB(255,255,255)
	line.BackgroundTransparency = 0.85
	line.Parent = row

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -80, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = module.Name
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.Parent = row

	-- toggle button
	toggle.Size = UDim2.new(0, 40, 0, 20)
	toggle.Position = UDim2.new(1, -45, 0.5, -10)
	toggle.BackgroundColor3 = Color3.fromRGB(180,180,180)
	toggle.Text = ""
	toggle.Parent = row

	local settingsButton = Instance.new("TextButton")
	settingsButton.Size = UDim2.new(0,18,0,18)
	settingsButton.Position = UDim2.new(1,-92,0.5,-9)
	settingsButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
	settingsButton.Text = "S"
	settingsButton.TextColor3 = Color3.fromRGB(255,255,255)
	settingsButton.Font = Enum.Font.GothamBold
	settingsButton.TextSize = 12
	settingsButton.Parent = row

	settingsButton.MouseButton1Click:Connect(function()
		print(module.Name .. " settings") -- settings menu placeholder
	end)
	
	-- info button
	local info = Instance.new("TextButton")
	info.Size = UDim2.new(0, 18, 0, 18)
	info.Position = UDim2.new(1, -70, 0.5, -9)
	info.BackgroundColor3 = Color3.fromRGB(60,60,60)
	info.Text = "i"
	info.TextColor3 = Color3.fromRGB(255,255,255)
	info.Font = Enum.Font.GothamBold
	info.TextSize = 12
	info.Parent = row

	-- tooltip window
	local tooltipGui = Instance.new("Frame")
	tooltipGui.Size = UDim2.new(0, 220, 0, 120)
	tooltipGui.Position = UDim2.new(0.5, -110, 0.5, -60)
	tooltipGui.BackgroundColor3 = Color3.fromRGB(20,20,20)
	tooltipGui.Visible = false
	tooltipGui.Parent = gui

	local tooltipTitle = Instance.new("TextLabel")
	tooltipTitle.Size = UDim2.new(1, -20, 0, 25)
	tooltipTitle.Position = UDim2.new(0, 10, 0, 5)
	tooltipTitle.BackgroundTransparency = 1
	tooltipTitle.Text = module.Name
	tooltipTitle.TextColor3 = Color3.fromRGB(255,255,255)
	tooltipTitle.Font = Enum.Font.GothamBold
	tooltipTitle.TextSize = 16
	tooltipTitle.Parent = tooltipGui

	local tooltipText = Instance.new("TextLabel")
	tooltipText.Size = UDim2.new(1, -20, 1, -40)
	tooltipText.Position = UDim2.new(0, 10, 0, 30)
	tooltipText.BackgroundTransparency = 1
	tooltipText.Text = module.Tooltip
	tooltipText.TextColor3 = Color3.fromRGB(200,200,200)
	tooltipText.TextWrapped = true
	tooltipText.Font = Enum.Font.Gotham
	tooltipText.TextSize = 13
	tooltipText.Parent = tooltipGui

	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 20, 0, 20)
	close.Position = UDim2.new(0, 5, 0, 5)
	close.BackgroundColor3 = Color3.fromRGB(200,50,50)
	close.Text = "X"
	close.TextColor3 = Color3.fromRGB(255,255,255)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 12
	close.Parent = tooltipGui

	-- toggle logic
	local function update()
		if module.Mode == "Toggle" then
			module.Enabled = not module.Enabled

			toggle.BackgroundColor3 =
				module.Enabled and Color3.fromRGB(255,255,255)
				or Color3.fromRGB(180,180,180)

			module.Callback(module.Enabled)
		else
			module.Callback()
			module.Enabled = false
		end
	end

	row.MouseButton1Click:Connect(update)

	-- tooltip open
	info.MouseButton1Click:Connect(function()
		tooltipGui.Visible = true
	end)

	close.MouseButton1Click:Connect(function()
		tooltipGui.Visible = false
	end)

	-- draggable tooltip
	local UIS = game:GetService("UserInputService")
	local dragging, startPos, dragStart

	tooltipGui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = tooltipGui.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			tooltipGui.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	table.insert(modules, module)

	return module
end

-- MODULES

CreateModule({
	Tab = "Combat",
	Name = "Test Module",
	Tooltip = "prints hi",
	Mode = "Button",

	Callback = function()
		print("hi")
	end
})
