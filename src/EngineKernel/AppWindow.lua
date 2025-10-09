local AppWindow = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindowMover = require(ReplicatedStorage.EngineKernel.WindowMover)

function AppWindow:Init(title, appName)
	local player = game.Players.LocalPlayer
	local desktopGui = player:WaitForChild("PlayerGui"):WaitForChild("DesktopGui")
	local taskbar = desktopGui:WaitForChild("Taskbar")

	-- Main frame of the window
	local gui = Instance.new("Frame")
	gui.Name = appName or "AppWindow"
	gui.Size = UDim2.new(0.35, 0, 0.45, 0)
	gui.Position = UDim2.new(0.325, 0, 0.3, 0)
	gui.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	gui.BorderSizePixel = 0
	gui.Active = true
	gui.Visible = true
	gui.Parent = desktopGui

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 25)
	titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = gui

	local titleText = Instance.new("TextLabel")
	titleText.Name = "TitleText"
	titleText.Size = UDim2.new(1, -90, 1, 0)
	titleText.BackgroundTransparency = 1
	titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.Text = "  " .. (title or "Untitled App")
	titleText.Parent = titleBar

	-- Button constructor
	local function makeButton(name, text, color, offset)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0, 25, 1, 0)
		btn.Position = UDim2.new(1, offset, 0, 0)
		btn.BackgroundColor3 = color
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.BorderSizePixel = 0
		btn.Parent = titleBar
		return btn
	end

	-- Control buttons
	local closeButton = makeButton("CloseButton", "X", Color3.fromRGB(200, 50, 50), -25)
	local maximizeButton = makeButton("MaximizeButton", "⧉", Color3.fromRGB(80, 80, 80), -50)
	local minimizeButton = makeButton("MinimizeButton", "—", Color3.fromRGB(80, 80, 80), -75)

	-- 🔹 Button on Taskbar
	local taskButton = Instance.new("ImageButton")
	taskButton.Name = appName or "TaskButton_" .. title
	taskButton.Size = UDim2.new(0.02, 0, 0.974, 0)
	taskButton.Position = UDim2.new(0.125, 0, 0.026, 0)
	taskButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	taskButton.Image = "rbxassetid://135303389500761"
	taskButton.BorderSizePixel = 0
	taskButton.ZIndex = 11
	taskButton.Parent = taskbar

	-- Hide/show apps using taskbar button
	local minimized = false
	taskButton.MouseButton1Click:Connect(function()
		if minimized then
			gui.Visible = true
			minimized = false
		else
			gui.Visible = false
			minimized = true
		end
	end)

	-- Button minimize
	minimizeButton.MouseButton1Click:Connect(function()
		gui.Visible = false
		minimized = true
	end)

	-- Button close
	closeButton.MouseButton1Click:Connect(function()
		taskButton:Destroy()
		gui:Destroy()
	end)

	-- Button maximize
	maximizeButton.MouseButton1Click:Connect(function()
		if gui.Size == UDim2.new(1, 0, 1, -25) then
			gui.Size = UDim2.new(0.35, 0, 0.45, 0)
			gui.Position = UDim2.new(0.325, 0, 0.3, 0)
		else
			gui.Size = UDim2.new(1, 0, 1, -25)
			gui.Position = UDim2.new(0, 0, 0, 25)
		end
	end)

	-- Window Move
	WindowMover:EnableDragging(gui, titleBar)

	print("[AppWindow] '" .. (title or "Untitled App") .. "' initialized.")
	return gui
end

return AppWindow
