-- WindowManager2 Module 
local WindowManager = {}
local topOrder = 1
local guis = {}

-- Đăng ký một GUI (ScreenGui) để quản lý
function WindowManager.RegisterGUI(gui)
	if not gui:IsA("ScreenGui") then return end

	gui.DisplayOrder = topOrder
	table.insert(guis, gui)

	-- Tự động tăng DisplayOrder khi người dùng click vào GUI (Frame chính)
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

-- Đăng ký tất cả ScreenGui trong PlayerGui
function WindowManager.RegisterAllGUIs(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("ScreenGui") then
			WindowManager.RegisterGUI(obj)
		end
	end
end

return WindowManager
