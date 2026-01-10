local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindowManager = require(ReplicatedStorage:WaitForChild("Hyggshi_OS_Engine")
	:WaitForChild("src")
	:WaitForChild("Window")
	:WaitForChild("WindowManager2"))

-- Lấy GUI người chơi
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Lấy UI của 2 app
local mane = playerGui:WaitForChild("mane")

-- Đăng ký các ScreenGui (dùng DisplayOrder)
WindowManager.RegisterGUI(mane)
