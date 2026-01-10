local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindowManager = require(ReplicatedStorage:WaitForChild("Hyggshi_OS_Engine")
	:WaitForChild("src")
	:WaitForChild("Window")
	:WaitForChild("WindowManager"))

-- Register all frames in the Desktop ScreenGui.
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local App_Screen_Gui = playerGui:WaitForChild("App_Screen_Gui")

WindowManager.RegisterAll(App_Screen_Gui)
