-- Hyggshi OS Window Animation Module for Roblox Studio
-- A unique OS style combining smooth curves, gentle bounces, and cozy aesthetics
-- Place this ModuleScript in ReplicatedStorage or ServerStorage

local TweenService = game:GetService("TweenService")

local HyggshiAnimator = {}
HyggshiAnimator.__index = HyggshiAnimator

-- Default settings for Hyggshi OS style
local DEFAULT_SETTINGS = {
	AnimationTime = 0.45,
	StartScale = 0.88,
	StartTransparency = 0.65,
	EasingStyle = Enum.EasingStyle.Exponential,
	EasingDirection = Enum.EasingDirection.Out,
	UseGentleBounce = true,       -- Signature gentle bounce
	UseSoftGlow = true,            -- Soft glow effect
	UseFloatIn = true,             -- Floats up slightly
	FloatOffset = 15,              -- Pixels to float from
	CornerRounding = true          -- Emphasizes rounded corners
}

-- Create a new Hyggshi OS window animator
function HyggshiAnimator.new(window, customSettings)
	local self = setmetatable({}, HyggshiAnimator)

	self.window = window
	self.settings = {}

	-- Merge custom settings with defaults
	for key, value in pairs(DEFAULT_SETTINGS) do
		self.settings[key] = customSettings and customSettings[key] or value
	end

	-- Store original size only (position is managed by GUI constraints)
	self.originalSize = window.Size

	-- Store original transparency values for all descendants
	self.originalTransparencies = {}
	for _, descendant in pairs(window:GetDescendants()) do
		if descendant:IsA("GuiObject") then
			local isTextObject = descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox")
			local isImageObject = descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")

			self.originalTransparencies[descendant] = {
				Background = descendant.BackgroundTransparency,
				Text = isTextObject and descendant.TextTransparency or nil,
				Image = isImageObject and descendant.ImageTransparency or nil
			}
		end
	end

	-- Apply corner rounding if enabled
	if self.settings.CornerRounding then
		self:ApplyCornerRounding(window)
	end

	return self
end

-- Apply rounded corners to window (Hyggshi style)
function HyggshiAnimator:ApplyCornerRounding(window)
	if not window:FindFirstChild("UICorner") then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = window
	end
end

-- Calculate centered position based on size (without changing AnchorPoint)
-- This function is no longer used but kept for reference
local function GetCenteredPosition(originalPos, originalSize, newSize)
	-- Calculate the offset needed to center the window
	local offsetX = (originalSize.X.Offset - newSize.X.Offset) / 2
	local offsetY = (originalSize.Y.Offset - newSize.Y.Offset) / 2

	return UDim2.new(
		originalPos.X.Scale,
		originalPos.X.Offset + offsetX,
		originalPos.Y.Scale,
		originalPos.Y.Offset + offsetY
	)
end

-- Show window with Hyggshi OS style animation
function HyggshiAnimator:Show()
	local window = self.window
	local settings = self.settings

	-- Calculate initial size (slightly smaller)
	local startSize = UDim2.new(
		self.originalSize.X.Scale * settings.StartScale,
		self.originalSize.X.Offset * settings.StartScale,
		self.originalSize.Y.Scale * settings.StartScale,
		self.originalSize.Y.Offset * settings.StartScale
	)

	-- Set initial state
	window.Size = startSize

	-- Set initial transparency (soft fade)
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

	-- Create smooth exponential tween
	local tweenInfo = TweenInfo.new(
		settings.AnimationTime,
		settings.EasingStyle,
		settings.EasingDirection
	)

	-- Tween size back to original
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = self.originalSize
	})

	-- Smooth fade-in with slight delay (Hyggshi's cozy feel)
	task.wait(0.08)

	local transparencyTweenInfo = TweenInfo.new(
		settings.AnimationTime * 0.9,
		Enum.EasingStyle.Sine,
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

	-- Gentle bounce at the end (signature Hyggshi effect)
	if settings.UseGentleBounce then
		sizeTween.Completed:Connect(function()
			local bounceInfo = TweenInfo.new(
				0.25,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.Out
			)

			-- Slight overshoot
			local bounceTween = TweenService:Create(window, bounceInfo, {
				Size = UDim2.new(
					self.originalSize.X.Scale * 1.015,
					self.originalSize.X.Offset * 1.015,
					self.originalSize.Y.Scale * 1.015,
					self.originalSize.Y.Offset * 1.015
				)
			})
			bounceTween:Play()

			-- Settle back to original size
			bounceTween.Completed:Connect(function()
				local settleInfo = TweenInfo.new(
					0.2,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.InOut
				)
				local settleTween = TweenService:Create(window, settleInfo, {
					Size = self.originalSize
				})
				settleTween:Play()
			end)
		end)
	end

	return sizeTween
end

-- Hide window with Hyggshi OS style animation
function HyggshiAnimator:Hide()
	local window = self.window
	local settings = self.settings

	-- Hyggshi close: gentle shrink and fade
	local tweenInfo = TweenInfo.new(
		settings.AnimationTime * 0.7,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.In
	)

	-- Calculate target size
	local targetSize = UDim2.new(
		self.originalSize.X.Scale * settings.StartScale,
		self.originalSize.X.Offset * settings.StartScale,
		self.originalSize.Y.Scale * settings.StartScale,
		self.originalSize.Y.Offset * settings.StartScale
	)

	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = targetSize
	})

	-- Smooth fade out
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

-- Hyggshi OS special: Cozy minimize (gently shrinks to corner)
function HyggshiAnimator:CozyMinimize(targetCorner)
	local window = self.window

	-- Default to bottom-right corner (cozy dock position)
	local minimizeTarget = targetCorner or UDim2.new(0.95, 0, 0.95, 0)

	local tweenInfo = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.Out
	)

	-- Shrink to small rounded bubble
	local sizeTween = TweenService:Create(window, tweenInfo, {
		Size = UDim2.new(0, 60, 0, 60),
		Position = minimizeTarget
	})

	-- Fade but keep slightly visible (cozy aesthetic)
	for descendant, originalTrans in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, tweenInfo, {
				BackgroundTransparency = 0.7
			}):Play()

			if originalTrans.Text then
				TweenService:Create(descendant, tweenInfo, {
					TextTransparency = 1
				}):Play()
			end

			if originalTrans.Image then
				TweenService:Create(descendant, tweenInfo, {
					ImageTransparency = 0.7
				}):Play()
			end
		end
	end

	sizeTween:Play()

	return sizeTween
end

-- Hyggshi OS special: Restore from cozy minimize
function HyggshiAnimator:CozyRestore()
	local window = self.window

	local tweenInfo = TweenInfo.new(
		0.5,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.Out
	)

	-- Restore size
	local restoreTween = TweenService:Create(window, tweenInfo, {
		Size = self.originalSize
	})

	-- Restore transparency
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

	restoreTween:Play()

	-- Add gentle bounce on restore
	restoreTween.Completed:Connect(function()
		local bounceInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
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
			TweenService:Create(window, bounceInfo, {
				Size = self.originalSize
			}):Play()
		end)
	end)

	return restoreTween
end

-- Hyggshi OS special: Warm pulse (attention getter)
function HyggshiAnimator:WarmPulse()
	local window = self.window

	local pulseInfo = TweenInfo.new(
		0.3,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out,
		0, -- No repeat
		true -- Reverse (auto returns to original)
	)

	local pulseTween = TweenService:Create(window, pulseInfo, {
		Size = UDim2.new(
			self.originalSize.X.Scale * 1.03,
			self.originalSize.X.Offset * 1.03,
			self.originalSize.Y.Scale * 1.03,
			self.originalSize.Y.Offset * 1.03
		)
	})

	pulseTween:Play()

	return pulseTween
end

-- Toggle window visibility
function HyggshiAnimator:Toggle()
	if self.window.Visible then
		return self:Hide()
	else
		return self:Show()
	end
end

-- Update settings
function HyggshiAnimator:UpdateSettings(newSettings)
	for key, value in pairs(newSettings) do
		if self.settings[key] ~= nil then
			self.settings[key] = value
		end
	end
end

return HyggshiAnimator