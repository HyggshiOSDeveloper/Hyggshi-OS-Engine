-- macOS-style Window Opening Animation Module for Roblox Studio
-- Place this ModuleScript in ReplicatedStorage or ServerStorage

local TweenService = game:GetService("TweenService")

local macOS = {}
macOS.__index = macOS

-- Default settings
local DEFAULT_SETTINGS = {
	AnimationTime = 0.3,
	StartScale = 0.7,
	StartTransparency = 0.5,
	EasingStyle = Enum.EasingStyle.Quart,
	EasingDirection = Enum.EasingDirection.Out
}

-- Create a new window animator
function macOS.new(window, customSettings)
	local self = setmetatable({}, macOS)

	self.window = window
	self.settings = {}

	-- Merge custom settings with defaults
	for key, value in pairs(DEFAULT_SETTINGS) do
		self.settings[key] = customSettings and customSettings[key] or value
	end

	-- Store original properties
	self.originalSize = window.Size
	self.originalPosition = window.Position

	-- Store original transparency values for all descendants
	self.originalTransparencies = {}
	for _, descendant in pairs(window:GetDescendants()) do
		if descendant:IsA("GuiObject") then
			local textTrans = nil
			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
				textTrans = descendant.TextTransparency
			end

			local imageTrans = nil
			if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
				imageTrans = descendant.ImageTransparency
			end

			self.originalTransparencies[descendant] = {
				Background = descendant.BackgroundTransparency,
				Text = textTrans,
				Image = imageTrans
			}
		end
	end

	return self
end

-- Show window with animation
function macOS:Show()
	local window = self.window
	local settings = self.settings

	-- Set initial state (small and slightly transparent)
	window.Size = UDim2.new(
		self.originalSize.X.Scale * settings.StartScale,
		self.originalSize.X.Offset * settings.StartScale,
		self.originalSize.Y.Scale * settings.StartScale,
		self.originalSize.Y.Offset * settings.StartScale
	)

	-- Ensure window is centered during scale
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	-- Set initial transparency for all descendants
	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			descendant.BackgroundTransparency = math.min(1, originalTrans.Background + settings.StartTransparency)

			if originalTrans.Text then
				descendant.TextTransparency = settings.StartTransparency
			end

			if originalTrans.Image then
				descendant.ImageTransparency = math.min(1, originalTrans.Image + settings.StartTransparency)
			end
		end
	end

	window.Visible = true

	-- Create tween info
	local tweenInfo = TweenInfo.new(
		settings.AnimationTime,
		settings.EasingStyle,
		settings.EasingDirection
	)

	-- Tween size back to original
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = self.originalSize
	})

	-- Tween transparency back to original
	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, tweenInfo, {
				BackgroundTransparency = originalTrans.Background
			}):Play()

			if originalTrans.Text then
				TweenService:Create(descendant, tweenInfo, {
					TextTransparency = 0
				}):Play()
			end

			if originalTrans.Image then
				TweenService:Create(descendant, tweenInfo, {
					ImageTransparency = originalTrans.Image
				}):Play()
			end
		end
	end

	sizeTween:Play()

	return sizeTween
end

-- Hide window with animation
function macOS:Hide()
	local window = self.window
	local settings = self.settings

	-- Create tween info (slightly faster close)
	local tweenInfo = TweenInfo.new(
		settings.AnimationTime * 0.8,
		settings.EasingStyle,
		Enum.EasingDirection.In
	)

	-- Tween size down
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = UDim2.new(
			self.originalSize.X.Scale * settings.StartScale,
			self.originalSize.X.Offset * settings.StartScale,
			self.originalSize.Y.Scale * settings.StartScale,
			self.originalSize.Y.Offset * settings.StartScale
		)
	})

	-- Tween transparency
	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, tweenInfo, {
				BackgroundTransparency = math.min(1, originalTrans.Background + settings.StartTransparency)
			}):Play()

			if originalTrans.Text then
				TweenService:Create(descendant, tweenInfo, {
					TextTransparency = settings.StartTransparency
				}):Play()
			end

			if originalTrans.Image then
				TweenService:Create(descendant, tweenInfo, {
					ImageTransparency = math.min(1, originalTrans.Image + settings.StartTransparency)
				}):Play()
			end
		end
	end

	sizeTween:Play()
	sizeTween.Completed:Connect(function()
		window.Visible = false
	end)

	return sizeTween
end

-- Toggle window visibility
function macOS:Toggle()
	if self.window.Visible then
		return self:Hide()
	else
		return self:Show()
	end
end

-- Update settings
function macOS:UpdateSettings(newSettings)
	for key, value in pairs(newSettings) do
		if self.settings[key] ~= nil then
			self.settings[key] = value
		end
	end
end

return macOS