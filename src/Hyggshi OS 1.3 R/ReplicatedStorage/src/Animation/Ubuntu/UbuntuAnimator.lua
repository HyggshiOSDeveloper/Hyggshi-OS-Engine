-- Ubuntu-style Window Opening Animation Module for Roblox Studio
-- Place this ModuleScript in ReplicatedStorage or ServerStorage

local TweenService = game:GetService("TweenService")

local UbuntuAnimator = {}
UbuntuAnimator.__index = UbuntuAnimator

-- Default settings for Ubuntu-style animation
local DEFAULT_SETTINGS = {
	AnimationTime = 0.28,
	StartScale = 0.85,
	StartTransparency = 0.8,
	EasingStyle = Enum.EasingStyle.Back,  -- Ubuntu uses back easing
	EasingDirection = Enum.EasingDirection.Out,
	UseZoomEffect = true,         -- Ubuntu's signature zoom from center
	UseElasticBounce = false,     -- Optional wobbly effect
	FadeDelay = 0.05              -- Slight delay before fade
}

-- Create a new window animator
function UbuntuAnimator.new(window, customSettings)
	local self = setmetatable({}, UbuntuAnimator)

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

-- Show window with Ubuntu-style animation
function UbuntuAnimator:Show()
	local window = self.window
	local settings = self.settings

	-- Set initial state (smaller and transparent - Ubuntu zoom effect)
	window.Size = UDim2.new(
		self.originalSize.X.Scale * settings.StartScale,
		self.originalSize.X.Offset * settings.StartScale,
		self.originalSize.Y.Scale * settings.StartScale,
		self.originalSize.Y.Offset * settings.StartScale
	)

	-- Ubuntu zooms from center
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	-- Set initial transparency
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

	-- Create tween info with Back easing (Ubuntu's signature)
	local tweenInfo = TweenInfo.new(
		settings.AnimationTime,
		settings.UseElasticBounce and Enum.EasingStyle.Elastic or settings.EasingStyle,
		settings.EasingDirection
	)

	-- Tween size with bounce/overshoot effect
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = self.originalSize
	})

	-- Delayed fade-in (Ubuntu fades slightly after zoom starts)
	task.wait(settings.FadeDelay)

	-- Tween transparency with smooth fade
	local transparencyTweenInfo = TweenInfo.new(
		settings.AnimationTime - settings.FadeDelay,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, transparencyTweenInfo, {
				BackgroundTransparency = originalTrans.Background
			}):Play()

			if originalTrans.Text then
				TweenService:Create(descendant, transparencyTweenInfo, {
					TextTransparency = 0
				}):Play()
			end

			if originalTrans.Image then
				TweenService:Create(descendant, transparencyTweenInfo, {
					ImageTransparency = originalTrans.Image
				}):Play()
			end
		end
	end

	sizeTween:Play()

	return sizeTween
end

-- Hide window with Ubuntu-style animation
function UbuntuAnimator:Hide()
	local window = self.window
	local settings = self.settings

	-- Ubuntu close is reverse zoom with quick fade
	local tweenInfo = TweenInfo.new(
		settings.AnimationTime * 0.75,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.In
	)

	-- Tween size down with reverse zoom
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = UDim2.new(
			self.originalSize.X.Scale * settings.StartScale,
			self.originalSize.X.Offset * settings.StartScale,
			self.originalSize.Y.Scale * settings.StartScale,
			self.originalSize.Y.Offset * settings.StartScale
		)
	})

	-- Quick fade out
	local transparencyTweenInfo = TweenInfo.new(
		settings.AnimationTime * 0.6,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.In
	)

	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, transparencyTweenInfo, {
				BackgroundTransparency = math.min(1, originalTrans.Background + settings.StartTransparency)
			}):Play()

			if originalTrans.Text then
				TweenService:Create(descendant, transparencyTweenInfo, {
					TextTransparency = settings.StartTransparency
				}):Play()
			end

			if originalTrans.Image then
				TweenService:Create(descendant, transparencyTweenInfo, {
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

-- Workspace switch effect (Ubuntu's workspace animation)
function UbuntuAnimator:WorkspaceSwitch(direction)
	local window = self.window
	direction = direction or "left"

	local slideDistance = 100
	local targetPosition

	if direction == "left" then
		targetPosition = UDim2.new(
			self.originalPosition.X.Scale,
			self.originalPosition.X.Offset - slideDistance,
			self.originalPosition.Y.Scale,
			self.originalPosition.Y.Offset
		)
	elseif direction == "right" then
		targetPosition = UDim2.new(
			self.originalPosition.X.Scale,
			self.originalPosition.X.Offset + slideDistance,
			self.originalPosition.Y.Scale,
			self.originalPosition.Y.Offset
		)
	elseif direction == "up" then
		targetPosition = UDim2.new(
			self.originalPosition.X.Scale,
			self.originalPosition.X.Offset,
			self.originalPosition.Y.Scale,
			self.originalPosition.Y.Offset - slideDistance
		)
	else -- down
		targetPosition = UDim2.new(
			self.originalPosition.X.Scale,
			self.originalPosition.X.Offset,
			self.originalPosition.Y.Scale,
			self.originalPosition.Y.Offset + slideDistance
		)
	end

	local tweenInfo = TweenInfo.new(
		0.35,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.InOut
	)

	-- Slide and fade
	local positionTween = TweenService:Create(window, tweenInfo, {
		Position = targetPosition
	})

	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, tweenInfo, {
				BackgroundTransparency = math.min(1, originalTrans.Background + 0.6)
			}):Play()
		end
	end

	positionTween:Play()
	positionTween.Completed:Connect(function()
		window.Visible = false
		window.Position = self.originalPosition
	end)

	return positionTween
end

-- Magic Lamp effect (Ubuntu's fun minimize animation)
function UbuntuAnimator:MagicLamp(targetPosition)
	local window = self.window

	-- Target position (usually dock/panel position)
	local lampTarget = targetPosition or UDim2.new(0.5, 0, 1, 0)

	local tweenInfo = TweenInfo.new(
		0.4,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.In
	)

	-- Create warping effect by animating to a point
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = UDim2.new(0, 40, 0, 40),
		Position = lampTarget
	})

	-- Fade and squish
	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, tweenInfo, {
				BackgroundTransparency = 1
			}):Play()

			if originalTrans.Text then
				TweenService:Create(descendant, tweenInfo, {
					TextTransparency = 1
				}):Play()
			end

			if originalTrans.Image then
				TweenService:Create(descendant, tweenInfo, {
					ImageTransparency = 1
				}):Play()
			end
		end
	end

	sizeTween:Play()
	sizeTween.Completed:Connect(function()
		window.Visible = false
		-- Reset properties
		window.Size = self.originalSize
		window.Position = self.originalPosition
	end)

	return sizeTween
end

-- Toggle window visibility
function UbuntuAnimator:Toggle()
	if self.window.Visible then
		return self:Hide()
	else
		return self:Show()
	end
end

-- Update settings
function UbuntuAnimator:UpdateSettings(newSettings)
	for key, value in pairs(newSettings) do
		if self.settings[key] ~= nil then
			self.settings[key] = value
		end
	end
end

return UbuntuAnimator