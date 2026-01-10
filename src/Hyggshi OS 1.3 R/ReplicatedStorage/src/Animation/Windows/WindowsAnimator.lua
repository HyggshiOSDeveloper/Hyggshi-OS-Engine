-- Windows-style Window Opening Animation Module for Roblox Studio
-- Place this ModuleScript in ReplicatedStorage or ServerStorage

local TweenService = game:GetService("TweenService")

local WindowAnimator = {}
WindowAnimator.__index = WindowAnimator

-- Default settings for Windows-style animation
local DEFAULT_SETTINGS = {
	AnimationTime = 0.25,
	StartScale = 0.95,
	StartTransparency = 1.0,
	EasingStyle = Enum.EasingStyle.Sine,
	EasingDirection = Enum.EasingDirection.Out,
	UseSlideDown = true,         -- Windows slides down slightly
	SlideOffset = -20,            -- Pixels to slide down from
	UseBounce = false            -- Optional subtle bounce
}

-- Create a new window animator
function WindowAnimator.new(window, customSettings)
	local self = setmetatable({}, WindowAnimator)

	self.window = window
	self.settings = {}

	-- Merge custom settings with defaults
	for key, value in pairs(DEFAULT_SETTINGS) do
		self.settings[key] = customSettings and customSettings[key] or value
	end

	-- Store original properties (NO POSITION SAVING)
	self.originalSize = window.Size

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

-- Show window with Windows-style animation
function WindowAnimator:Show()
	local window = self.window
	local settings = self.settings

	-- Store current position for slide animation
	local currentPosition = window.Position

	-- Set initial state (slightly smaller and fully transparent)
	window.Size = UDim2.new(
		self.originalSize.X.Scale * settings.StartScale,
		self.originalSize.X.Offset * settings.StartScale,
		self.originalSize.Y.Scale * settings.StartScale,
		self.originalSize.Y.Offset * settings.StartScale
	)

	-- Ensure window is centered during scale
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	-- Set initial position (slide down effect)
	if settings.UseSlideDown then
		window.Position = UDim2.new(
			currentPosition.X.Scale,
			currentPosition.X.Offset,
			currentPosition.Y.Scale,
			currentPosition.Y.Offset + settings.SlideOffset
		)
	end

	-- Set initial transparency for all descendants (fully transparent)
	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			descendant.BackgroundTransparency = 1

			if originalTrans.Text then
				descendant.TextTransparency = 1
			end

			if originalTrans.Image then
				descendant.ImageTransparency = 1
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

	-- Tween position if using slide down
	local positionTween
	if settings.UseSlideDown then
		positionTween = TweenService:Create(window, tweenInfo, {
			Position = currentPosition
		})
		positionTween:Play()
	end

	-- Tween transparency back to original (Windows has quick fade-in)
	local transparencyTweenInfo = TweenInfo.new(
		settings.AnimationTime * 0.7, -- Faster fade than scale
		Enum.EasingStyle.Linear,
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

	-- Optional bounce effect (Windows 11 style)
	if settings.UseBounce then
		sizeTween.Completed:Connect(function()
			local bounceInfo = TweenInfo.new(
				0.15,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			)

			local bounceTween = TweenService:Create(window, bounceInfo, {
				Size = UDim2.new(
					self.originalSize.X.Scale * 1.02,
					self.originalSize.X.Offset * 1.02,
					self.originalSize.Y.Scale * 1.02,
					self.originalSize.Y.Offset * 1.02
				)
			})
			bounceTween:Play()

			bounceTween.Completed:Connect(function()
				local returnTween = TweenService:Create(window, bounceInfo, {
					Size = self.originalSize
				})
				returnTween:Play()
			end)
		end)
	end

	return sizeTween
end

-- Hide window with Windows-style animation
function WindowAnimator:Hide()
	local window = self.window
	local settings = self.settings

	-- Create tween info (faster close, typical Windows behavior)
	local tweenInfo = TweenInfo.new(
		settings.AnimationTime * 0.6,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.In
	)

	-- Tween size down slightly
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = UDim2.new(
			self.originalSize.X.Scale * settings.StartScale,
			self.originalSize.X.Offset * settings.StartScale,
			self.originalSize.Y.Scale * settings.StartScale,
			self.originalSize.Y.Offset * settings.StartScale
		)
	})

	-- Tween transparency (Windows fades out quickly)
	local transparencyTweenInfo = TweenInfo.new(
		settings.AnimationTime * 0.5,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.In
	)

	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, transparencyTweenInfo, {
				BackgroundTransparency = 1
			}):Play()

			if originalTrans.Text then
				TweenService:Create(descendant, transparencyTweenInfo, {
					TextTransparency = 1
				}):Play()
			end

			if originalTrans.Image then
				TweenService:Create(descendant, transparencyTweenInfo, {
					ImageTransparency = 1
				}):Play()
			end
		end
	end

	sizeTween:Play()
	sizeTween.Completed:Connect(function()
		window.Visible = false
		-- Position is NOT reset
	end)

	return sizeTween
end

-- Minimize animation (Windows-style to taskbar)
function WindowAnimator:Minimize(targetPosition)
	local window = self.window
	local settings = self.settings

	local tweenInfo = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.In
	)

	-- Target position (usually bottom of screen)
	local minimizeTarget = targetPosition or UDim2.new(0.5, 0, 1, 50)

	-- Tween to small size and target position
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = UDim2.new(0, 0, 0, 0),
		Position = minimizeTarget
	})

	-- Fade out
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
		-- Reset size only (position is NOT reset)
		window.Size = self.originalSize
	end)

	return sizeTween
end

-- Toggle window visibility
function WindowAnimator:Toggle()
	if self.window.Visible then
		return self:Hide()
	else
		return self:Show()
	end
end

-- Update settings
function WindowAnimator:UpdateSettings(newSettings)
	for key, value in pairs(newSettings) do
		if self.settings[key] ~= nil then
			self.settings[key] = value
		end
	end
end

return WindowAnimator