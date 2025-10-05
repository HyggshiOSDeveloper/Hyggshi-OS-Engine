local Desktop = {}

function Desktop:Init()
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local gui = Instance.new("ScreenGui")
	gui.Name = "DesktopGui"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = playerGui

	local background = Instance.new("ImageLabel")
	background.Name = "ImageBackground"
	background.Size = UDim2.new(1, 0, 1, 0)
	background.Image = "rbxassetid://129548761614383"
	background.ZIndex = 1
	background.Parent = gui
end

return Desktop
