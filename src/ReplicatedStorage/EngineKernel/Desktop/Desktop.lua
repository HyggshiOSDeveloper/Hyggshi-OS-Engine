-- Please Use ModuleScript type

local Desktop = {}

function Desktop:Init()
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local DesktopGui = Instance.new("ScreenGui")
	DesktopGui.Name = "DesktopGui"
	DesktopGui.IgnoreGuiInset = true
	DesktopGui.ResetOnSpawn = false
	DesktopGui.Parent = playerGui

	local bg = Instance.new("ImageLabel")
	bg.Size = UDim2.fromScale(1, 1)
	bg.Image = "rbxassetid://129548761614383"
	bg.BackgroundTransparency = 1
	bg.Parent = DesktopGui

	local wm = Instance.new("ImageLabel")
	wm.Size = UDim2.new(0.204, 0, 0.114, 0)
	wm.Position = UDim2.new(0.728, 0, 0.731, 0)
	wm.BackgroundTransparency = 1
	wm.Image = "rbxassetid://136905301410953"
	wm.ImageTransparency = 0.5
	wm.Parent = DesktopGui

	print("[Desktop] GUI created.")
end

return Desktop
