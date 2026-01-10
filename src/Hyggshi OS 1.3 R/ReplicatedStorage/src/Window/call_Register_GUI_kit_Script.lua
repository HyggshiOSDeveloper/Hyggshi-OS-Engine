local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindowManager = require(ReplicatedStorage:WaitForChild("Hyggshi_OS_Engine")
	:WaitForChild("src")
	:WaitForChild("Window")
	:WaitForChild("WindowManager2"))

-- Get the player GUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Get the UI of the two apps.
local mane = playerGui:WaitForChild("mane")

-- Register ScreenGuis (using DisplayOrder)
WindowManager.RegisterGUI(mane)
