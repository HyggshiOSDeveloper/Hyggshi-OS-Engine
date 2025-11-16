-- 📄 MainClient.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Kernel = ReplicatedStorage:WaitForChild("EngineKernel")
local ErrorLogger = require(Kernel.Utils.ErrorLogger)

local Desktop = require(Kernel.Desktop.Desktop)
local Taskbar = require(Kernel.Taskbar.Taskbar)
local GUIManager = require(Kernel.GUIManager)


-- 🧠 Initialize the system GUI
local success, err = pcall(function()
	Desktop:Init()
	Taskbar:Init()
	GUIManager:Init()
end)

-- 🧩 If there is an error that the GUI cannot render → Blue Screen is displayed
if not success then
	warn("[HyggshiOS] Lỗi render GUI: " .. tostring(err))
	ErrorLogger:ScanScripts()
else
	ErrorLogger:ScanScripts() -- Check if any module is broken
end


local HyggshiAPI = require(Kernel.WindowAPI.HyggshiAPI)

local MyApp = {}
MyApp.Name = "XP Tour"
MyApp.Icon = "rbxassetid://18647100139"

MyApp.OnLaunch = function()
	HyggshiAPI.MessageBox(MyApp.Name, "Test", MyApp.Icon)
end

-- Launch sample app
pcall(function()
	MyApp.OnLaunch()
end)