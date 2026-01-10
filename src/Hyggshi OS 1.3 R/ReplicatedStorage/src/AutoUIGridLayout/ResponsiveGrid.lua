-- Responsive UIGridLayout Module
-- Automatically adjusts grid cell size based on device type (Mobile, Tablet, Laptop, Desktop)

local ResponsiveGrid = {}
ResponsiveGrid.__index = ResponsiveGrid

local UserInputService = game:GetService("UserInputService")

-- Device type detection with detailed logging
local function getDeviceType()
	local isTouchEnabled = UserInputService.TouchEnabled
	local isKeyboardEnabled = UserInputService.KeyboardEnabled
	local isMouseEnabled = UserInputService.MouseEnabled
	local isGamepadEnabled = UserInputService.GamepadEnabled

	-- Check screen size
	local viewportSize = workspace.CurrentCamera.ViewportSize
	local screenWidth = viewportSize.X
	local screenHeight = viewportSize.Y

	-- Try to get platform safely
	local platform = nil
	local success = pcall(function()
		platform = UserInputService:GetPlatform()
	end)

	-- Debug info
	print("=== Device Detection ===")
	if success and platform then
		print("Platform:", platform)
	end
	print("Touch Enabled:", isTouchEnabled)
	print("Keyboard Enabled:", isKeyboardEnabled)
	print("Mouse Enabled:", isMouseEnabled)
	print("Gamepad Enabled:", isGamepadEnabled)
	print("Screen Width:", screenWidth)
	print("Screen Height:", screenHeight)

	-- Determine device type
	local deviceType

	-- Check platform first if available (most reliable for real devices)
	if success and platform then
		if platform == Enum.Platform.IOS or platform == Enum.Platform.Android then
			-- Real mobile device
			if screenWidth < 600 or screenHeight < 600 then
				deviceType = "Mobile"
			else
				deviceType = "Tablet"
			end
			-- Console check
		elseif platform == Enum.Platform.XBoxOne or isGamepadEnabled then
			deviceType = "Desktop" -- Treat consoles as desktop
			-- Windows/Mac/Desktop platforms
		elseif platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.UWP then
			if screenWidth >= 1920 then
				deviceType = "Desktop"
			elseif screenWidth >= 1024 then
				deviceType = "Laptop"
			else
				deviceType = "Tablet"
			end
		end
	end

	-- Fallback to input-based detection if platform not available
	if not deviceType then
		-- Mobile: Touch only, no mouse/keyboard
		if isTouchEnabled and not isMouseEnabled and not isKeyboardEnabled then
			if screenWidth < 600 then
				deviceType = "Mobile"
			else
				deviceType = "Tablet"
			end
			-- Tablet: Touch + some other input or larger touch screen
		elseif isTouchEnabled and screenWidth >= 600 and screenWidth < 1024 then
			deviceType = "Tablet"
			-- Laptop: Medium screen
		elseif screenWidth >= 1024 and screenWidth < 1920 then
			deviceType = "Laptop"
			-- Desktop: Large screen
		elseif screenWidth >= 1920 then
			deviceType = "Desktop"
			-- Final fallback
		else
			deviceType = "Laptop"
		end
	end

	print("Detected Device Type:", deviceType)
	print("=======================")

	return deviceType
end

-- Create a new responsive grid
function ResponsiveGrid.new(gridLayout, config)
	if not gridLayout then
		error("ResponsiveGrid.new: gridLayout parameter is required!")
	end

	if not gridLayout:IsA("UIGridLayout") then
		error("ResponsiveGrid.new: gridLayout must be a UIGridLayout instance!")
	end

	local self = setmetatable({}, ResponsiveGrid)

	self.gridLayout = gridLayout
	self.config = config or {}

	-- Default configurations for each device type
	self.presets = {
		Mobile = {
			CellSize = UDim2.new(0, 25, 0, 25),
			CellPadding = UDim2.new(0, 4, 0, 4),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		Tablet = {
			CellSize = UDim2.new(0, 50, 0, 50),
			CellPadding = UDim2.new(0, 10, 0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		Laptop = {
			CellSize = UDim2.new(0, 45, 0, 45),
			CellPadding = UDim2.new(0, 10, 0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		Desktop = {
			CellSize = UDim2.new(0, 60, 0, 60),
			CellPadding = UDim2.new(0, 10, 0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}

	-- Merge custom config with presets
	if self.config and type(self.config) == "table" then
		for deviceType, settings in pairs(self.config) do
			if self.presets[deviceType] and type(settings) == "table" then
				print("Merging custom config for:", deviceType)
				for property, value in pairs(settings) do
					self.presets[deviceType][property] = value
					print("  " .. property .. " =", value)
				end
			end
		end
	end

	-- Apply initial settings
	self:update()

	-- Listen for viewport changes
	self.viewportConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		self:update()
	end)

	return self
end

-- Update grid layout based on current device
function ResponsiveGrid:update()
	local deviceType = getDeviceType()
	local preset = self.presets[deviceType]

	if preset then
		print("Applying preset for " .. deviceType .. ":")

		-- Apply properties in specific order to ensure CellSize is set properly
		-- Set CellSize first as it's the most critical property
		if preset.CellSize then
			local success, err = pcall(function()
				self.gridLayout.CellSize = preset.CellSize
			end)
			if success then
				print("  ✓ CellSize = " .. tostring(preset.CellSize))
			else
				warn("  ✗ Failed to set CellSize: " .. err)
			end
		end

		-- Then apply CellPadding
		if preset.CellPadding then
			local success, err = pcall(function()
				self.gridLayout.CellPadding = preset.CellPadding
			end)
			if success then
				print("  ✓ CellPadding = " .. tostring(preset.CellPadding))
			else
				warn("  ✗ Failed to set CellPadding: " .. err)
			end
		end

		-- Apply remaining properties
		for property, value in pairs(preset) do
			if property ~= "CellSize" and property ~= "CellPadding" then
				local success, err = pcall(function()
					self.gridLayout[property] = value
				end)
				if success then
					print("  ✓ " .. property .. " = " .. tostring(value))
				else
					warn("  ✗ Failed to set " .. property .. ": " .. err)
				end
			end
		end

		-- Force a layout recalculation by updating AbsoluteContentSize
		task.wait()
		if self.gridLayout.Parent then
			-- Trigger a layout refresh by modifying a property slightly
			local currentPadding = self.gridLayout.CellPadding
			self.gridLayout.CellPadding = UDim2.new(currentPadding.X.Scale, currentPadding.X.Offset, currentPadding.Y.Scale, currentPadding.Y.Offset)
		end

		print("Grid layout updated successfully!")
	else
		warn("No preset found for device type: " .. deviceType)
	end
end

-- Clean up connections
function ResponsiveGrid:destroy()
	if self.viewportConnection then
		self.viewportConnection:Disconnect()
		self.viewportConnection = nil
	end
	print("ResponsiveGrid destroyed")
end

return ResponsiveGrid