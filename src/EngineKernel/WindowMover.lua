-- WindowMover.lua
local UserInputService = game:GetService("UserInputService")

local WindowMover = {}
WindowMover.Active = false
WindowMover.CurrentWindow = nil
WindowMover.Offset = Vector2.new()

-- Initialize drag and drop event
function WindowMover:EnableDragging(window, dragBar)
	if not window or not dragBar then return end

	dragBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Active = true
			self.CurrentWindow = window
			local mousePos = UserInputService:GetMouseLocation()
			self.Offset = Vector2.new(mousePos.X - window.Position.X.Offset, mousePos.Y - window.Position.Y.Offset)
		end
	end)

	dragBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Active = false
			self.CurrentWindow = nil
		end
	end)
end

-- Update position when mouse moves
UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and WindowMover.Active and WindowMover.CurrentWindow then
		local mousePos = UserInputService:GetMouseLocation()
		local newPos = UDim2.new(0, mousePos.X - WindowMover.Offset.X, 0, mousePos.Y - WindowMover.Offset.Y)
		WindowMover.CurrentWindow.Position = newPos
	end
end)

return WindowMover
