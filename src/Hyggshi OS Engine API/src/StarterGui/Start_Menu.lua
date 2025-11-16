-- StarterGui/Button/Start_Menu.lua

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local StartMenuController = require(game.ReplicatedStorage:WaitForChild("Hyggshi_OS_Engine"):WaitForChild("src"):WaitForChild("StartMenuController"):WaitForChild("StartMenuController"))

local button = script.Parent
local menu = button.Parent:WaitForChild("Starticon")


button.MouseButton1Click:Connect(function()
	StartMenuController.Toggle()
end)

-- Close when pressed out
mouse.Button1Down:Connect(function()
	if not menu.Visible then return end
	local x,y = mouse.X, mouse.Y
	local inFrame = x >= menu.AbsolutePosition.X and x <= menu.AbsolutePosition.X + menu.AbsoluteSize.X
		and y >= menu.AbsolutePosition.Y and y <= menu.AbsolutePosition.Y + menu.AbsoluteSize.Y
	local inBtn = x >= button.AbsolutePosition.X and x <= button.AbsolutePosition.X + button.AbsoluteSize.X
		and y >= button.AbsolutePosition.Y and y <= button.AbsolutePosition.Y + button.AbsoluteSize.Y
	if not inFrame and not inBtn then
		StartMenuController.Close()
	end
end)

local btn = script.Parent.Parent.Parent.StartMenuFrame.App_Frame1.App_Button_1
btn.MouseButton1Click:Connect(function()
	-- Open GUI app
	local player = game.Players.LocalPlayer
	local Frame = player.PlayerGui.App_Screen_Gui.mycomputer
	Frame.Visible = true

	-- Close Start Menu
	StartMenuController.Close()
end)
