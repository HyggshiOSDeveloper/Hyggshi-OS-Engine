-- WindowManager Module
local WindowManager = {}
local topZ = 1
local windows = {}

-- Register a window to manage
function WindowManager.Register(frame)
	if not frame:IsA("Frame") and not frame:IsA("TextButton") then return end
	frame.Active = true
	frame.Selectable = true
	table.insert(windows, frame)

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			topZ = topZ + 1
			frame.ZIndex = topZ
		end
	end)
end

-- Batch registration (e.g. all Frames in 1 ScreenGui)
function WindowManager.RegisterAll(parent)
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("Frame") then
			WindowManager.Register(obj)
		end
	end
end

return WindowManager
