-- It will be applied to 1 types of Custom

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindowAnimator = require(ReplicatedStorage:WaitForChild("Custom"))

local window = script.Parent:WaitForChild("MainWindow")

-- Just pass the effect name as a string
local animator = WindowAnimator.new(window, "quantum_snap")

task.wait(1)
animator:Show()

-- Optional: Connect buttons if they exist
local openButton = script.Parent:FindFirstChild("OpenButton")
local closeButton = window:FindFirstChild("CloseButton")

if openButton then
	openButton.MouseButton1Click:Connect(function()
		animator:Show()
	end)
end

if closeButton then
	closeButton.MouseButton1Click:Connect(function()
		animator:Hide()
	end)
end