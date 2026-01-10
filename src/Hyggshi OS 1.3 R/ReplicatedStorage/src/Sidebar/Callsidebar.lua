-- LocalScript to initialize the sidebar
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Correct path to the module
local SidebarModule = require(
	ReplicatedStorage:WaitForChild("Hyggshi_OS_Engine")
		:WaitForChild("src")
		:WaitForChild("Sidebar")
		:WaitForChild("SidebarModule")
)

-- Create the sidebar
local sidebar = SidebarModule.new(playerGui)

-- Add gadgets
sidebar:AddClockGadget()

sidebar:AddCalendarGadget()


-- Optional: Add a custom gadget with a button
sidebar:AddCustomGadget("My Gadget", 120, function(gadget)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 30)
	label.Position = UDim2.new(0, 10, 0, 30)
	label.BackgroundTransparency = 1
	label.Text = "Custom Content!"
	label.TextColor3 = Color3.fromRGB(255, 200, 100)
	label.TextSize = 16
	label.Font = Enum.Font.GothamBold
	label.Parent = gadget

	-- Add a button inside
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 35)
	button.Position = UDim2.new(0.05, 0, 0, 70)
	button.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
	button.Text = "Click Me!"
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	button.Font = Enum.Font.GothamBold
	button.Parent = gadget

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button

	button.MouseButton1Click:Connect(function()
		label.Text = "Button Clicked!"
	end)
end)