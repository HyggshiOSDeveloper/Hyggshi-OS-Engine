local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindowManager = require(ReplicatedStorage:WaitForChild("Hyggshi_OS_Engine")
	:WaitForChild("src")
	:WaitForChild("Window")
	:WaitForChild("WindowManager2"))

-- Get player GUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Get UI of 2 apps
local MinesweeperMain = playerGui:WaitForChild("MinesweeperGui")
local CustomIDE = playerGui:WaitForChild("CustomIDE")

-- Register ScreenGui (using DisplayOrder) for LolcalScript Build GUI
WindowManager.RegisterGUI(MinesweeperMain)
WindowManager.RegisterGUI(CustomIDE)
  