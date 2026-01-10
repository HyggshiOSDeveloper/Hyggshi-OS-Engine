local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindowManager = require(ReplicatedStorage:WaitForChild("Hyggshi_OS_Engine")
	:WaitForChild("src")
	:WaitForChild("Window")
	:WaitForChild("WindowManager"))

-- Đăng ký toàn bộ Frame trong ScreenGui Desktop
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local App_Screen_Gui = playerGui:WaitForChild("App_Screen_Gui")

WindowManager.RegisterAll(App_Screen_Gui)
