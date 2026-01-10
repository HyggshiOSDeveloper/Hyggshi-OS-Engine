-- Sidebar Gadgets Module
-- Place this ModuleScript in ReplicatedStorage
-- Name it "SidebarModule"

local TweenService = game:GetService("TweenService")

local SidebarModule = {}
SidebarModule.__index = SidebarModule

-- Constructor
function SidebarModule.new(playerGui)
	local self = setmetatable({}, SidebarModule)

	self.playerGui = playerGui
	self.screenGui = nil
	self.sidebar = nil
	self.scrollFrame = nil
	self.toggleButton = nil
	self.sidebarVisible = true
	self.gadgets = {}

	self:Initialize()

	return self
end

-- Initialize the sidebar
function SidebarModule:Initialize()
	-- Create ScreenGui
	self.screenGui = Instance.new("ScreenGui")
	self.screenGui.Name = "SidebarGadgets"
	self.screenGui.ResetOnSpawn = false
	self.screenGui.Parent = self.playerGui
	self.screenGui.DisplayOrder = 1
	self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.screenGui.Parent = self.playerGui

	-- Create Sidebar Container
	self.sidebar = Instance.new("Frame")
	self.sidebar.Name = "Sidebar"
	self.sidebar.Size = UDim2.new(0, 200, 0.897, 0)
	self.sidebar.Position = UDim2.new(1, -000, 0.009, 0)
	self.sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	self.sidebar.BackgroundTransparency = 0.3
	self.sidebar.BorderSizePixel = 0
	self.sidebar.Parent = self.screenGui

	self.UICorner = Instance.new("UICorner")
	self.UICorner.Name = "UICorner"
	self.UICorner.Archivable = true
	self.UICorner.Parent = self.sidebar

	-- Create ScrollingFrame for gadgets
	self.scrollFrame = Instance.new("ScrollingFrame")
	self.scrollFrame.Name = "GadgetsContainer"
	self.scrollFrame.Size = UDim2.new(1, -10, 1, -20)
	self.scrollFrame.Position = UDim2.new(0, 5, 0, 10)
	self.scrollFrame.BackgroundTransparency = 1
	self.scrollFrame.BorderSizePixel = 0
	self.scrollFrame.ScrollBarThickness = 6
	self.scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	self.scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	self.scrollFrame.Parent = self.sidebar

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Parent = self.scrollFrame

	-- Create toggle button
	self.toggleButton = Instance.new("TextButton")
	self.toggleButton.Name = "ToggleButton"
	self.toggleButton.Size = UDim2.new(0.013, 0, 0.091, 0)
	self.toggleButton.Position = UDim2.new(0.987, 0, 0.909, 0)
	self.toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	self.toggleButton.BackgroundTransparency = 1
	self.toggleButton.BorderSizePixel = 1
	self.toggleButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
	self.toggleButton.Text = "<<"
	self.toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	self.toggleButton.TextSize = 18
	self.toggleButton.Font = Enum.Font.GothamBold
	self.toggleButton.Parent = self.screenGui

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 8)
	toggleCorner.Parent = self.toggleButton

	self.toggleButton.MouseButton1Click:Connect(function()
		self:ToggleSidebar()
	end)

	print("Windows 7 Sidebar Module initialized successfully!")
end

-- Create a basic gadget frame
function SidebarModule:CreateGadget(name, height)
	local gadget = Instance.new("Frame")
	gadget.Name = name
	gadget.Size = UDim2.new(0, 180, 0, height)
	gadget.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	gadget.BackgroundTransparency = 0.2
	gadget.BorderSizePixel = 1
	gadget.BorderColor3 = Color3.fromRGB(80, 80, 80)
	gadget.Parent = self.scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = gadget

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 0, 25)
	title.Position = UDim2.new(0, 5, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 14
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = gadget

	return gadget
end

-- Add Clock Gadget
function SidebarModule:AddClockGadget()
	local clockGadget = self:CreateGadget("Clock", 120)

	local timeLabel = Instance.new("TextLabel")
	timeLabel.Name = "TimeLabel"
	timeLabel.Size = UDim2.new(1, -20, 0, 40)
	timeLabel.Position = UDim2.new(0, 10, 0, 35)
	timeLabel.BackgroundTransparency = 1
	timeLabel.Text = "00:00:00"
	timeLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
	timeLabel.TextSize = 32
	timeLabel.Font = Enum.Font.GothamBold
	timeLabel.Parent = clockGadget

	local dateLabel = Instance.new("TextLabel")
	dateLabel.Name = "DateLabel"
	dateLabel.Size = UDim2.new(1, -20, 0, 20)
	dateLabel.Position = UDim2.new(0, 10, 0, 80)
	dateLabel.BackgroundTransparency = 1
	dateLabel.Text = "Monday, December 2"
	dateLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	dateLabel.TextSize = 14
	dateLabel.Font = Enum.Font.Gotham
	dateLabel.Parent = clockGadget

	-- Update clock
	spawn(function()
		while clockGadget.Parent do
			wait(1)
			local time = os.date("*t")
			timeLabel.Text = string.format("%02d:%02d:%02d", time.hour, time.min, time.sec)
			dateLabel.Text = os.date("%A, %B %d")
		end
	end)

	table.insert(self.gadgets, {name = "Clock", frame = clockGadget})
	return clockGadget
end

-- Add CPU Meter Gadget
function SidebarModule:AddCPUMeterGadget()
	local cpuGadget = self:CreateGadget("CPU Meter", 140)

	local cpuBar = Instance.new("Frame")
	cpuBar.Name = "CPUBar"
	cpuBar.Size = UDim2.new(0.9, 0, 0, 20)
	cpuBar.Position = UDim2.new(0.05, 0, 0, 40)
	cpuBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	cpuBar.BorderSizePixel = 1
	cpuBar.BorderColor3 = Color3.fromRGB(80, 80, 80)
	cpuBar.Parent = cpuGadget

	local cpuFill = Instance.new("Frame")
	cpuFill.Name = "Fill"
	cpuFill.Size = UDim2.new(0, 0, 1, 0)
	cpuFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	cpuFill.BorderSizePixel = 0
	cpuFill.Parent = cpuBar

	local cpuLabel = Instance.new("TextLabel")
	cpuLabel.Size = UDim2.new(1, 0, 0, 20)
	cpuLabel.Position = UDim2.new(0, 0, 0, 65)
	cpuLabel.BackgroundTransparency = 1
	cpuLabel.Text = "CPU: 0%"
	cpuLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	cpuLabel.TextSize = 12
	cpuLabel.Font = Enum.Font.Gotham
	cpuLabel.Parent = cpuGadget

	local memBar = Instance.new("Frame")
	memBar.Name = "MemBar"
	memBar.Size = UDim2.new(0.9, 0, 0, 20)
	memBar.Position = UDim2.new(0.05, 0, 0, 90)
	memBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	memBar.BorderSizePixel = 1
	memBar.BorderColor3 = Color3.fromRGB(80, 80, 80)
	memBar.Parent = cpuGadget

	local memFill = Instance.new("Frame")
	memFill.Name = "Fill"
	memFill.Size = UDim2.new(0, 0, 1, 0)
	memFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	memFill.BorderSizePixel = 0
	memFill.Parent = memBar

	local memLabel = Instance.new("TextLabel")
	memLabel.Size = UDim2.new(1, 0, 0, 20)
	memLabel.Position = UDim2.new(0, 0, 0, 115)
	memLabel.BackgroundTransparency = 1
	memLabel.Text = "Memory: 0%"
	memLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	memLabel.TextSize = 12
	memLabel.Font = Enum.Font.Gotham
	memLabel.Parent = cpuGadget

	-- Simulate CPU/Memory usage
	spawn(function()
		while cpuGadget.Parent do
			wait(0.5)
			local cpu = math.random(10, 80)
			local mem = math.random(30, 90)

			cpuFill:TweenSize(UDim2.new(cpu/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
			cpuLabel.Text = "CPU: " .. cpu .. "%"

			memFill:TweenSize(UDim2.new(mem/100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
			memLabel.Text = "Memory: " .. mem .. "%"
		end
	end)

	table.insert(self.gadgets, {name = "CPU Meter", frame = cpuGadget})
	return cpuGadget
end

-- Add Calendar Gadget
function SidebarModule:AddCalendarGadget()
	local calendarGadget = self:CreateGadget("Calendar", 190)

	local monthLabel = Instance.new("TextLabel")
	monthLabel.Size = UDim2.new(1, -20, 0, 20)
	monthLabel.Position = UDim2.new(0, 10, 0, 30)
	monthLabel.BackgroundTransparency = 1
	monthLabel.Text = os.date("%B %Y")
	monthLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
	monthLabel.TextSize = 16
	monthLabel.Font = Enum.Font.GothamBold
	monthLabel.Parent = calendarGadget

	local daysFrame = Instance.new("Frame")
	daysFrame.Size = UDim2.new(1, -20, 0, 100)
	daysFrame.Position = UDim2.new(0, 10, 0, 55)
	daysFrame.BackgroundTransparency = 1
	daysFrame.Parent = calendarGadget

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 22, 0, 20)
	gridLayout.CellPadding = UDim2.new(0, 2, 0, 2)
	gridLayout.Parent = daysFrame

	-- Create calendar days
	for i = 1, 31 do
		local dayLabel = Instance.new("TextLabel")
		dayLabel.BackgroundTransparency = 1
		dayLabel.Text = tostring(i)
		dayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		dayLabel.TextSize = 11
		dayLabel.Font = Enum.Font.Gotham

		if i == tonumber(os.date("%d")) then
			dayLabel.BackgroundTransparency = 0
			dayLabel.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 4)
			corner.Parent = dayLabel
		end

		dayLabel.Parent = daysFrame
	end

	table.insert(self.gadgets, {name = "Calendar", frame = calendarGadget})
	return calendarGadget
end

-- Add Battery Meter Gadget
function SidebarModule:AddBatteryGadget()
	local batteryGadget = self:CreateGadget("Battery", 100)

	local batteryIcon = Instance.new("Frame")
	batteryIcon.Size = UDim2.new(0, 80, 0, 40)
	batteryIcon.Position = UDim2.new(0.5, -40, 0, 35)
	batteryIcon.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	batteryIcon.BorderSizePixel = 2
	batteryIcon.BorderColor3 = Color3.fromRGB(150, 150, 150)
	batteryIcon.Parent = batteryGadget

	local batteryCorner = Instance.new("UICorner")
	batteryCorner.CornerRadius = UDim.new(0, 4)
	batteryCorner.Parent = batteryIcon

	local batteryFill = Instance.new("Frame")
	batteryFill.Name = "Fill"
	batteryFill.Size = UDim2.new(0.85, 0, 0.7, 0)
	batteryFill.Position = UDim2.new(0.075, 0, 0.15, 0)
	batteryFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	batteryFill.BorderSizePixel = 0
	batteryFill.Parent = batteryIcon

	local batteryTip = Instance.new("Frame")
	batteryTip.Size = UDim2.new(0, 4, 0, 12)
	batteryTip.Position = UDim2.new(1, 0, 0.5, -6)
	batteryTip.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
	batteryTip.BorderSizePixel = 0
	batteryTip.Parent = batteryIcon

	local batteryText = Instance.new("TextLabel")
	batteryText.Size = UDim2.new(1, 0, 0, 20)
	batteryText.Position = UDim2.new(0, 0, 0, 78)
	batteryText.BackgroundTransparency = 1
	batteryText.Text = "100% Charged"
	batteryText.TextColor3 = Color3.fromRGB(200, 200, 200)
	batteryText.TextSize = 12
	batteryText.Font = Enum.Font.Gotham
	batteryText.Parent = batteryGadget

	-- Simulate battery drain
	spawn(function()
		local battery = 100
		while batteryGadget.Parent do
			wait(2)
			battery = math.max(20, battery - math.random(0, 2))
			batteryFill:TweenSize(UDim2.new(battery/100 * 0.85, 0, 0.7, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)

			if battery > 50 then
				batteryFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
			elseif battery > 20 then
				batteryFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
			else
				batteryFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
			end

			batteryText.Text = battery .. "% Charged"
		end
	end)

	table.insert(self.gadgets, {name = "Battery", frame = batteryGadget})
	return batteryGadget
end

-- Add a custom gadget
function SidebarModule:AddCustomGadget(name, height, setupFunction)
	local gadget = self:CreateGadget(name, height)

	if setupFunction then
		setupFunction(gadget)
	end

	table.insert(self.gadgets, {name = name, frame = gadget})
	return gadget
end

-- Add Button Gadget
function SidebarModule:AddButtonGadget(buttonText, onClick)
	local buttonGadget = self:CreateGadget("Quick Actions", 80)

	local button = Instance.new("TextButton")
	button.Name = "ActionButton"
	button.Size = UDim2.new(0.9, 0, 0, 40)
	button.Position = UDim2.new(0.05, 0, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	button.BorderSizePixel = 0
	button.Text = buttonText or "Click Me"
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	button.Font = Enum.Font.GothamBold
	button.Parent = buttonGadget

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = button

	-- Hover effect
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(70, 140, 220)
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	end)

	-- Click handler
	if onClick then
		button.MouseButton1Click:Connect(onClick)
	end

	table.insert(self.gadgets, {name = "Quick Actions", frame = buttonGadget})
	return buttonGadget, button
end

-- Toggle sidebar visibility
function SidebarModule:ToggleSidebar()
	self.sidebarVisible = not self.sidebarVisible

	local targetPos = self.sidebarVisible and UDim2.new(1, -210, 0.009, 0) or UDim2.new(1, -0, 0.009, 0)
	local buttonText = self.sidebarVisible and "<<" or ">>"

	self.sidebar:TweenPosition(targetPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
	self.toggleButton.Text = buttonText
end

-- Show sidebar
function SidebarModule:Show()
	if not self.sidebarVisible then
		self:ToggleSidebar()
	end
end

-- Hide sidebar
function SidebarModule:Hide()
	if self.sidebarVisible then
		self:ToggleSidebar()
	end
end

-- Remove a gadget by name
function SidebarModule:RemoveGadget(name)
	for i, gadget in ipairs(self.gadgets) do
		if gadget.name == name then
			gadget.frame:Destroy()
			table.remove(self.gadgets, i)
			return true
		end
	end
	return false
end

-- Destroy the entire sidebar
function SidebarModule:Destroy()
	if self.screenGui then
		self.screenGui:Destroy()
	end
	self.gadgets = {}
end

return SidebarModule