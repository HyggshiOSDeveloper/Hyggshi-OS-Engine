-- Custom Creative Window Animation Effects Module for Roblox Studio
-- ModuleScript: Custom

local TweenService = game:GetService("TweenService")

local Custom = {}
Custom.__index = Custom

-- Available effect presets
Custom.Effects = {
	PORTAL = "portal",            -- Spiraling portal entrance
	SHATTER = "shatter",          -- Glass shatter from center
	ORIGAMI = "origami",          -- Paper folding effect
	LIQUID = "liquid",            -- Liquid drop splash
	HOLOGRAM = "hologram",        -- Sci-fi hologram flicker
	SMOKE = "smoke",              -- Smoke dissipation
	NEON_PULSE = "neon_pulse",    -- Cyberpunk neon glow
	DREAMSCAPE = "dreamscape",    -- Surreal wavy entrance
	-- NEW EFFECTS --
	RETRO_TV = "retro_tv",        -- Old CRT TV switch on style
	QUANTUM_SNAP = "quantum_snap"
}

function Custom.new(window, effect)
	local self = setmetatable({}, Custom)

	self.window = window
	self.effect = effect or Custom.Effects.PORTAL
	self.originalSize = window.Size
	self.originalPosition = window.Position
	self.originalRotation = window.Rotation
	self.originalAnchor = window.AnchorPoint

	-- Store original transparency values (Updated to support Images)
	self.originalTransparencies = {}
	for _, descendant in pairs(window:GetDescendants()) do
		if descendant:IsA("GuiObject") then
			self.originalTransparencies[descendant] = {
				Background = descendant.BackgroundTransparency,
				Text = (descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox")) and descendant.TextTransparency or nil,
				Image = (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and descendant.ImageTransparency or nil
			}
		end
	end

	return self
end

-- ==========================================
-- ORIGINAL EFFECTS
-- ==========================================

-- PORTAL EFFECT
function Custom:ShowPortal()
	local window = self.window
	window.Size = UDim2.new(0, 0, 0, 0)
	window.Rotation = 180
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	self:_SetAllTransparent()
	window.Visible = true

	local spinTween = TweenService:Create(window, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = self.originalSize,
		Rotation = self.originalRotation
	})

	task.wait(0.1)
	self:_RestoreTransparencies(0.5)
	spinTween:Play()
	return spinTween
end

-- SHATTER EFFECT
function Custom:ShowShatter()
	local window = self.window
	window.Size = UDim2.new(self.originalSize.X.Scale * 1.3, 0, self.originalSize.Y.Scale * 1.3, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	self:_SetAllTransparent()
	window.Visible = true

	for i = 1, 3 do
		task.spawn(function()
			task.wait(i * 0.05)
			local pulse = TweenService:Create(window, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
				Size = UDim2.new(self.originalSize.X.Scale * (1.3 - i * 0.1), 0, self.originalSize.Y.Scale * (1.3 - i * 0.1), 0)
			})
			pulse:Play()
		end)
	end
	task.wait(0.2)

	local assembleTween = TweenService:Create(window, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = self.originalSize
	})

	self:_RestoreTransparencies(0.4)
	assembleTween:Play()
	return assembleTween
end

-- ORIGAMI EFFECT
function Custom:ShowOrigami()
	local window = self.window
	window.Size = UDim2.new(self.originalSize.X.Scale, 0, 0, 0)
	window.AnchorPoint = Vector2.new(0.5, 0)
	window.Position = UDim2.new(self.originalPosition.X.Scale, 0, self.originalPosition.Y.Scale, 0)

	self:_SetAllTransparent()
	window.Visible = true

	local unfoldVertical = TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(self.originalSize.X.Scale, 0, self.originalSize.Y.Scale, 0)
	})

	unfoldVertical:Play()
	unfoldVertical.Completed:Connect(function()
		window.AnchorPoint = Vector2.new(0.5, 0.5)
		window.Position = self.originalPosition

		local unfoldHorizontal = TweenService:Create(window, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = self.originalSize
		})
		unfoldHorizontal:Play()
		task.wait(0.1)
		self:_RestoreTransparencies(0.3)
	end)
	return unfoldVertical
end

-- LIQUID EFFECT
function Custom:ShowLiquid()
	local window = self.window
	window.Size = UDim2.new(self.originalSize.X.Scale * 0.3, 0, self.originalSize.Y.Scale * 0.1, 0)
	window.Position = UDim2.new(self.originalPosition.X.Scale, 0, self.originalPosition.Y.Scale - 0.2, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	self:_SetAllTransparent()
	window.Visible = true

	local dropTween = TweenService:Create(window, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = self.originalPosition
	})

	dropTween:Play()
	dropTween.Completed:Connect(function()
		local splashTween = TweenService:Create(window, TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
			Size = self.originalSize
		})
		splashTween:Play()
		self:_RestoreTransparencies(0.4)
	end)
	return dropTween
end

-- HOLOGRAM EFFECT
function Custom:ShowHologram()
	local window = self.window
	window.Size = self.originalSize
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	self:_SetAllTransparent()
	window.Visible = true

	for i = 1, 8 do
		task.spawn(function()
			task.wait(i * 0.04)
			local alpha = math.random(30, 90) / 100
			for descendant, original in pairs(self.originalTransparencies) do
				if descendant and descendant.Parent then
					descendant.BackgroundTransparency = 1 - alpha
					if original.Text then descendant.TextTransparency = 1 - alpha end
					if original.Image then descendant.ImageTransparency = 1 - alpha end
				end
			end
		end)
	end
	task.wait(0.35)
	self:_RestoreTransparencies(0.2)
	return task.wait(0.2)
end

-- SMOKE EFFECT
function Custom:ShowSmoke()
	local window = self.window
	window.Size = UDim2.new(self.originalSize.X.Scale * 1.4, 0, self.originalSize.Y.Scale * 1.4, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	self:_SetAllTransparent()
	window.Visible = true

	local condenseTween = TweenService:Create(window, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = self.originalSize
	})

	task.wait(0.1)
	self:_RestoreTransparencies(0.6)
	condenseTween:Play()
	return condenseTween
end

-- NEON PULSE EFFECT
function Custom:ShowNeonPulse()
	local window = self.window
	window.Size = UDim2.new(0, 0, 0, 0)
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	for descendant in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			descendant.BackgroundTransparency = 0.3
		end
	end
	window.Visible = true

	local burstTween = TweenService:Create(window, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(self.originalSize.X.Scale * 1.15, 0, self.originalSize.Y.Scale * 1.15, 0)
	})

	burstTween:Play()
	burstTween.Completed:Connect(function()
		local settleTween = TweenService:Create(window, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = self.originalSize
		})
		settleTween:Play()
		self:_RestoreTransparencies(0.25)
	end)
	return burstTween
end

-- DREAMSCAPE EFFECT
function Custom:ShowDreamscape()
	local window = self.window
	window.Size = UDim2.new(self.originalSize.X.Scale * 0.6, 0, self.originalSize.Y.Scale * 0.6, 0)
	window.Rotation = -15
	window.AnchorPoint = Vector2.new(0.5, 0.5)

	self:_SetAllTransparent()
	window.Visible = true

	local dreamTween = TweenService:Create(window, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
		Size = self.originalSize,
		Rotation = self.originalRotation
	})

	task.wait(0.15)
	self:_RestoreTransparencies(0.6)
	dreamTween:Play()
	return dreamTween
end

-- ==========================================
-- NEW CUSTOM EFFECTS
-- ==========================================

-- RETRO TV EFFECT (New): Expands Width then Height
function Custom:ShowRetroTV()
	local window = self.window
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	-- Start as a thin horizontal line
	window.Size = UDim2.new(0, 0, 0.005, 0) 

	self:_SetAllTransparent()
	window.Visible = true

	-- Phase 1: Expand Width
	local widthTween = TweenService:Create(window, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = UDim2.new(self.originalSize.X.Scale, self.originalSize.X.Offset, 0.005, 0)
	})
	widthTween:Play()

	-- Phase 2: Expand Height
	widthTween.Completed:Connect(function()
		local heightTween = TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = self.originalSize
		})
		heightTween:Play()

		-- Restore contents
		self:_RestoreTransparencies(0.2)
	end)

	return widthTween
end

-- GLITCH DECODE EFFECT (New): Jitters position and size
function Custom:ShowGlitchDecode()
	local window = self.window
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Visible = true

	local endPos = self.originalPosition

	task.spawn(function()
		local originalSize = self.originalSize

		-- 4 quick random glitches
		for i = 1, 4 do
			local randomX = (math.random() - 0.5) * 0.1
			local randomY = (math.random() - 0.5) * 0.1
			local randomScale = 0.9 + (math.random() * 0.2) 

			window.Position = UDim2.new(endPos.X.Scale + randomX, endPos.X.Offset, endPos.Y.Scale + randomY, endPos.Y.Offset)
			window.Size = UDim2.new(originalSize.X.Scale * randomScale, 0, originalSize.Y.Scale, 0)

			-- Randomly toggle visibility of elements
			for descendant, _ in pairs(self.originalTransparencies) do
				if descendant:IsA("GuiObject") then
					descendant.Visible = (math.random() > 0.4)
				end
			end
			task.wait(0.06)
		end

		-- Stabilize
		window.Position = endPos
		window.Size = self.originalSize

		for descendant, _ in pairs(self.originalTransparencies) do
			if descendant:IsA("GuiObject") then descendant.Visible = true end
		end

		local finalizeTween = TweenService:Create(window, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Size = self.originalSize,
			Position = self.originalPosition
		})
		finalizeTween:Play()
	end)

	return true
end

-- ==========================================
-- HELPER FUNCTIONS
-- ==========================================

function Custom:_SetAllTransparent()
	for descendant in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			descendant.BackgroundTransparency = 1
			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
				descendant.TextTransparency = 1
			end
			if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
				descendant.ImageTransparency = 1
			end
		end
	end
end

function Custom:_RestoreTransparencies(tweenTime)
	for descendant, original in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, TweenInfo.new(tweenTime), {
				BackgroundTransparency = original.Background or 0
			}):Play()
			if original.Text then
				TweenService:Create(descendant, TweenInfo.new(tweenTime), {TextTransparency = original.Text}):Play()
			end
			if original.Image then
				TweenService:Create(descendant, TweenInfo.new(tweenTime), {ImageTransparency = original.Image}):Play()
			end
		end
	end
end

-- QUANTUM SNAP EFFECT
function Custom:ShowQuantumSnap()
	local window = self.window
	window.Size = UDim2.new(0,8,0,8)
	window.AnchorPoint = Vector2.new(0.5,0.5)
	window.Position = self.originalPosition
	window.Rotation = 0

	for descendant in pairs(self.originalTransparencies) do
		if descendant.Parent then
			descendant.BackgroundTransparency = 1
			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
				descendant.TextTransparency = 1
			end
		end
	end

	window.Visible = true

	for i=1,5 do
		task.spawn(function()
			task.wait(i*0.03)
			local jitter = TweenService:Create(window, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
				Position = window.Position + UDim2.new(0,math.random(-3,3),0,math.random(-3,3))
			})
			jitter:Play()
		end)
	end

	task.wait(0.18)
	local snapTween = TweenService:Create(window, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = self.originalSize,
		Position = self.originalPosition
	})
	snapTween:Play()

	task.spawn(function()
		task.wait(0.1)
		for descendant, original in pairs(self.originalTransparencies) do
			if descendant.Parent then
				TweenService:Create(descendant, TweenInfo.new(0.25), {BackgroundTransparency = original.Background}):Play()
				if original.Text then
					TweenService:Create(descendant, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
				end
			end
		end
	end)

	return snapTween
end

-- ==========================================
-- MAIN ROUTER
-- ==========================================

function Custom:Show()
	-- Original Effects
	if self.effect == Custom.Effects.PORTAL then return self:ShowPortal()
	elseif self.effect == Custom.Effects.SHATTER then return self:ShowShatter()
	elseif self.effect == Custom.Effects.ORIGAMI then return self:ShowOrigami()
	elseif self.effect == Custom.Effects.LIQUID then return self:ShowLiquid()
	elseif self.effect == Custom.Effects.HOLOGRAM then return self:ShowHologram()
	elseif self.effect == Custom.Effects.SMOKE then return self:ShowSmoke()
	elseif self.effect == Custom.Effects.NEON_PULSE then return self:ShowNeonPulse()
	elseif self.effect == Custom.Effects.DREAMSCAPE then return self:ShowDreamscape()

		-- New Effects
	elseif self.effect == Custom.Effects.RETRO_TV then return self:ShowRetroTV()
	elseif self.effect == Custom.Effects.QUANTUM_SNAP then
		return self:ShowQuantumSnap()
	

	else return self:ShowPortal() end
end

function Custom:Hide()
	local window = self.window
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	local hideTween = TweenService:Create(window, tweenInfo, {
		Size = UDim2.new(0, 0, 0, 0)
	})

	for descendant in pairs(self.originalTransparencies) do
		if descendant and descendant.Parent then
			TweenService:Create(descendant, tweenInfo, {BackgroundTransparency = 1}):Play()
			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
				TweenService:Create(descendant, tweenInfo, {TextTransparency = 1}):Play()
			end
			if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
				TweenService:Create(descendant, tweenInfo, {ImageTransparency = 1}):Play()
			end
		end
	end

	hideTween:Play()
	hideTween.Completed:Connect(function()
		window.Visible = false
		window.Size = self.originalSize
		window.Rotation = self.originalRotation
		window.AnchorPoint = self.originalAnchor
	end)

	return hideTween
end

function Custom:Toggle()
	if self.window.Visible then
		return self:Hide()
	else
		return self:Show()
	end
end

return Custom