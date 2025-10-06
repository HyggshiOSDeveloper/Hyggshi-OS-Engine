-- ModuleScript: Taskbar.lua
-- Please Use ModuleScript type

local Taskbar = {}
local TweenService = game:GetService("TweenService")

function Taskbar:Init()
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- Check if desktop is available
	local desktopGui = playerGui:FindFirstChild("DesktopGui")
	if not desktopGui then
		warn("[Taskbar] No DesktopGui found. Make sure Desktop:Init() was called first.")
		return
	end

	-- Create Taskbar
	local bar = Instance.new("Frame")
	bar.Name = "Taskbar"
	bar.Size = UDim2.new(1, 0, 0, 38)
	bar.Position = UDim2.new(0, 0, 1, -38)
	bar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	bar.BorderSizePixel = 0
	bar.ZIndex = 10
	bar.Parent = desktopGui

	-- Right corner clock (CREATE IN ADVANCE so it won't be covered by the Start Menu)
	local clock = Instance.new("TextLabel")
	clock.Name = "Clock"
	clock.Size = UDim2.new(0, 100, 1, 0)
	clock.Position = UDim2.new(1, -100, 0, 0)
	clock.BackgroundTransparency = 1
	clock.TextColor3 = Color3.new(1, 1, 1)
	clock.TextXAlignment = Enum.TextXAlignment.Center
	clock.TextYAlignment = Enum.TextYAlignment.Center
	clock.Font = Enum.Font.Code
	clock.TextSize = 16
	clock.ZIndex = 11
	clock.Text = os.date("%H:%M:%S")
	clock.Parent = bar

	-- Update the clock
	task.spawn(function()
		while clock and clock.Parent do
			local success, err = pcall(function()
				clock.Text = os.date("%H:%M:%S")
			end)
			if not success then
				warn("[Taskbar] Clock update error:", err)
				break
			end
			task.wait(1)
		end
	end)

	-- Button Start
	local startBtn = Instance.new("TextButton")
	startBtn.Name = "StartButton"
	startBtn.Size = UDim2.new(0, 90, 1, 0)
	startBtn.Position = UDim2.new(0, 0, 0, 0)
	startBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	startBtn.TextColor3 = Color3.new(1, 1, 1)
	startBtn.Font = Enum.Font.SourceSansBold
	startBtn.TextSize = 14
	startBtn.Text = "⊞ Start"
	startBtn.ZIndex = 11
	startBtn.Parent = bar

	-- Start Menu
	local startMenu = Instance.new("Frame")
	startMenu.Name = "StartMenu"
	startMenu.Size = UDim2.new(0, 350, 0, 450)
	startMenu.Position = UDim2.new(0, 0, 1, -488)
	startMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	startMenu.BorderSizePixel = 0
	startMenu.ZIndex = 15
	startMenu.Visible = false
	startMenu.ClipsDescendants = true
	startMenu.Parent = desktopGui

	-- Rounded corners for Start Menu
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = startMenu

	-- Start Menu Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 60)
	header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	header.BorderSizePixel = 0
	header.ZIndex = 16
	header.Parent = startMenu

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 8)
	headerCorner.Parent = header

	local userLabel = Instance.new("TextLabel")
	userLabel.Size = UDim2.new(1, -20, 1, 0)
	userLabel.Position = UDim2.new(0, 10, 0, 0)
	userLabel.BackgroundTransparency = 1
	userLabel.TextColor3 = Color3.new(1, 1, 1)
	userLabel.Font = Enum.Font.SourceSansBold
	userLabel.TextSize = 20
	userLabel.TextXAlignment = Enum.TextXAlignment.Left
	userLabel.TextYAlignment = Enum.TextYAlignment.Center
	userLabel.Text = "👤 " .. player.Name
	userLabel.ZIndex = 17
	userLabel.Parent = header

	-- List of applications
	local appList = Instance.new("ScrollingFrame")
	appList.Name = "AppList"
	appList.Size = UDim2.new(1, -20, 1, -80)
	appList.Position = UDim2.new(0, 10, 0, 70)
	appList.BackgroundTransparency = 1
	appList.BorderSizePixel = 0
	appList.ScrollBarThickness = 6
	appList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	appList.ZIndex = 16
	appList.Parent = startMenu

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = appList

	-- Sample applications
	local apps = {
		{name = "📁 File Manager", desc = "Browse your files"},
		{name = "⚙️ Settings", desc = "System configuration"},
		{name = "🎮 Games", desc = "Play games"},
		{name = "🖼️ Gallery", desc = "View images"},
		{name = "🎵 Music Player", desc = "Listen to music"},
		{name = "📝 Notepad", desc = "Text editor"},
		{name = "🌐 Browser", desc = "Web browser"},
		{name = "📊 Task Manager", desc = "Manage processes"}
	}

	for i, app in ipairs(apps) do
		local appBtn = Instance.new("TextButton")
		appBtn.Name = "App" .. i
		appBtn.Size = UDim2.new(1, 0, 0, 50)
		appBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		appBtn.BorderSizePixel = 0
		appBtn.AutoButtonColor = false
		appBtn.Text = ""
		appBtn.ZIndex = 17
		appBtn.Parent = appList

		local appCorner = Instance.new("UICorner")
		appCorner.CornerRadius = UDim.new(0, 6)
		appCorner.Parent = appBtn

		local appName = Instance.new("TextLabel")
		appName.Size = UDim2.new(1, -10, 0, 25)
		appName.Position = UDim2.new(0, 10, 0, 5)
		appName.BackgroundTransparency = 1
		appName.TextColor3 = Color3.new(1, 1, 1)
		appName.Font = Enum.Font.SourceSansBold
		appName.TextSize = 16
		appName.TextXAlignment = Enum.TextXAlignment.Left
		appName.TextYAlignment = Enum.TextYAlignment.Top
		appName.Text = app.name
		appName.ZIndex = 18
		appName.Parent = appBtn

		local appDesc = Instance.new("TextLabel")
		appDesc.Size = UDim2.new(1, -10, 0, 15)
		appDesc.Position = UDim2.new(0, 10, 0, 28)
		appDesc.BackgroundTransparency = 1
		appDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
		appDesc.Font = Enum.Font.SourceSans
		appDesc.TextSize = 12
		appDesc.TextXAlignment = Enum.TextXAlignment.Left
		appDesc.TextYAlignment = Enum.TextYAlignment.Top
		appDesc.Text = app.desc
		appDesc.ZIndex = 18
		appDesc.Parent = appBtn

		-- Hover animation
		appBtn.MouseEnter:Connect(function()
			TweenService:Create(appBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			}):Play()
		end)

		appBtn.MouseLeave:Connect(function()
			TweenService:Create(appBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			}):Play()
		end)
	end

	-- Update canvas size
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		appList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
	end)
	appList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)

	-- Menu state variables
	local menuOpen = false

	-- Animation for Start Menu
	local function toggleStartMenu()
		menuOpen = not menuOpen

		if menuOpen then
			startMenu.Visible = true
			startMenu.Size = UDim2.new(0, 350, 0, 0)
			startMenu.Position = UDim2.new(0, 0, 1, -38)

			TweenService:Create(startMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 350, 0, 450),
				Position = UDim2.new(0, 0, 1, -488)
			}):Play()

			TweenService:Create(startBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			}):Play()
		else
			TweenService:Create(startMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 350, 0, 0),
				Position = UDim2.new(0, 0, 1, -38)
			}):Play()

			TweenService:Create(startBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			}):Play()

			task.wait(0.2)
			startMenu.Visible = false
		end
	end

	-- Hover effect for Start button
	startBtn.MouseEnter:Connect(function()
		if not menuOpen then
			TweenService:Create(startBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			}):Play()
		end
	end)

	startBtn.MouseLeave:Connect(function()
		if not menuOpen then
			TweenService:Create(startBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			}):Play()
		end
	end)

	-- Click to open/close Start Menu
	startBtn.MouseButton1Click:Connect(toggleStartMenu)

	-- Close menu when clicking outside
	local UserInputService = game:GetService("UserInputService")
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
			if menuOpen then
				local mousePos = UserInputService:GetMouseLocation()
				local menuPos = startMenu.AbsolutePosition
				local menuSize = startMenu.AbsoluteSize

				local isInsideMenu = mousePos.X >= menuPos.X and mousePos.X <= menuPos.X + menuSize.X
					and mousePos.Y >= menuPos.Y and mousePos.Y <= menuPos.Y + menuSize.Y

				local btnPos = startBtn.AbsolutePosition
				local btnSize = startBtn.AbsoluteSize
				local isInsideBtn = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X
					and mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y

				if not isInsideMenu and not isInsideBtn then
					toggleStartMenu()
				end
			end
		end
	end)

	print("[Taskbar] Initialized with Start Menu, animations, and working clock.")
end

return Taskbar
