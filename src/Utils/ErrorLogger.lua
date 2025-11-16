-- 🧠 ErrorLogger.lua

local ErrorLogger = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

local screenGui

-- Blue Screen
local function createBlueScreen(errorText)
	if screenGui then screenGui:Destroy() end

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BlueScreenOfDeath"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 999999
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 60, 180)
	bg.Parent = screenGui

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -80, 1, -80)
	label.Position = UDim2.new(0, 40, 0, 40)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.SourceSansBold
	label.TextScaled = true
	label.TextWrapped = true
	label.Text = "Oops! Hyggshi OS failed to initialize interface.\n\n" ..
		"Error details:\n" .. tostring(errorText) .. "\n\n" ..
		"Please check your EngineKernel structure or GUI script again."

	label.Parent = bg
	screenGui.Parent = playerGui
end

-- 🧩 Test GUI modules
function ErrorLogger:ScanScripts()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Kernel = ReplicatedStorage:FindFirstChild("EngineKernel")

	if not Kernel then
		createBlueScreen("EngineKernel folder not found in ReplicatedStorage.")
		return
	end

	local modules = {
		"Desktop.Desktop",
		"Taskbar.Taskbar",
		"GUIManager",
		"WindowAPI.HyggshiAPI",
		
	}

	local errorFound = false
	local errorDetails = {}

	for _, moduleName in ipairs(modules) do
		local ok, result = pcall(function()
			local path = Kernel
			for part in string.gmatch(moduleName, "[^%.]+") do
				path = path:FindFirstChild(part)
				if not path then
					error("Missing module: " .. moduleName)
				end
			end
			require(path)
		end)

		if not ok then
			errorFound = true
			table.insert(errorDetails, result)
		end
	end

	if errorFound then
		createBlueScreen(table.concat(errorDetails, "\n\n"))
	else

		if screenGui then
			screenGui:Destroy()
			screenGui = nil
		end
	end
end

return ErrorLogger
