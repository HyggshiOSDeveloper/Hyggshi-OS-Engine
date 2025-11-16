-- WindowManager2 Module 
local WindowManager = {}
local topOrder = 1
local guis = {}

-- Register a GUI (ScreenGui) for management
function WindowManager.RegisterGUI(gui)
	if not gui:IsA("ScreenGui") then return end

	gui.DisplayOrder = topOrder
	table.insert(guis, gui)

	-- Automatically increase DisplayOrder when user clicks on GUI (Main Frame)
	local root = gui:FindFirstChildWhichIsA("Frame")
	if root then
		root.Active = true
		root.Selectable = true

		root.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				topOrder += 1
				gui.DisplayOrder = topOrder
			end
		end)
	end
end

-- Register all ScreenGui in PlayerGui
function WindowManager.RegisterAllGUIs(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("ScreenGui") then
			WindowManager.RegisterGUI(obj)
		end
	end
end

return WindowManager
