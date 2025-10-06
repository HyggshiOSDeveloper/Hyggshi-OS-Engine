local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Kernel = ReplicatedStorage:WaitForChild("EngineKernel")

local Desktop = require(Kernel.Desktop.Desktop)
local Taskbar = require(Kernel.Taskbar.Taskbar)

Desktop:Init()
Taskbar:Init()
