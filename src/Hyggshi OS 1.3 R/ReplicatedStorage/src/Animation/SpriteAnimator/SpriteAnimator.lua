local SpriteAnimator = {}
SpriteAnimator.__index = SpriteAnimator

-- Constructor
function SpriteAnimator.new(imageLabel, config)
	local self = setmetatable({}, SpriteAnimator)

	-- Kiểm tra đầu vào
	if not imageLabel then
		error("SpriteAnimator.new(): imageLabel không được nil!")
		return nil
	end

	if not imageLabel:IsA("GuiObject") then
		error("SpriteAnimator.new(): Cần GuiObject (ImageLabel/ImageButton), nhận được: " .. imageLabel.ClassName)
		return nil
	end

	-- Cấu hình mặc định
	self.config = {
		FPS = config.FPS or 60,
		SPRITE_SIZE = config.SPRITE_SIZE or Vector2.new(64, 64),
		TOTAL_SPRITES = config.TOTAL_SPRITES or 119,
		SPRITES_PER_ROW = config.SPRITES_PER_ROW or 15
	}

	-- Thuộc tính
	self.imageLabel = imageLabel
	self.currentFrame = 1
	self.isPlaying = false
	self.connection = nil
	self.animationThread = nil

	return self
end

-- Cập nhật vị trí sprite
function SpriteAnimator:updateFrame(frameIndex)
	if not self.imageLabel or not self.imageLabel.Parent then
		return
	end

	local column = (frameIndex - 1) % self.config.SPRITES_PER_ROW
	local row = math.floor((frameIndex - 1) / self.config.SPRITES_PER_ROW)

	self.imageLabel.ImageRectOffset = Vector2.new(
		column * self.config.SPRITE_SIZE.X,
		row * self.config.SPRITE_SIZE.Y
	)
end

-- Phát animation
function SpriteAnimator:play()
	if self.isPlaying then return end
	if not self.imageLabel or not self.imageLabel.Parent then return end

	-- Reset về frame đầu
	self.currentFrame = 1
	self:updateFrame(self.currentFrame)

	-- Kiểm tra Visible
	local success, isVisible = pcall(function()
		return self.imageLabel.Visible
	end)

	if not success or not isVisible then return end

	self.isPlaying = true

	-- Tạo thread animation
	self.animationThread = task.spawn(function()
		while self.isPlaying do
			-- Kiểm tra object còn tồn tại
			if not self.imageLabel or not self.imageLabel.Parent then
				self.isPlaying = false
				break
			end

			-- Kiểm tra Visible
			local visSuccess, vis = pcall(function()
				return self.imageLabel.Visible
			end)

			if not visSuccess or not vis then
				self.isPlaying = false
				break
			end

			task.wait(1 / self.config.FPS)

			self.currentFrame = self.currentFrame + 1

			if self.currentFrame > self.config.TOTAL_SPRITES then
				self.currentFrame = 1
			end

			self:updateFrame(self.currentFrame)
		end

		self.isPlaying = false
	end)
end

-- Dừng animation
function SpriteAnimator:stop()
	self.isPlaying = false
	if self.animationThread then
		task.cancel(self.animationThread)
		self.animationThread = nil
	end
end

-- Tạm dừng tại frame hiện tại
function SpriteAnimator:pause()
	self.isPlaying = false
end

-- Tiếp tục từ frame hiện tại
function SpriteAnimator:resume()
	if self.isPlaying then return end
	if not self.imageLabel or not self.imageLabel.Parent then return end

	self.isPlaying = true

	self.animationThread = task.spawn(function()
		while self.isPlaying do
			if not self.imageLabel or not self.imageLabel.Parent then
				self.isPlaying = false
				break
			end

			local visSuccess, vis = pcall(function()
				return self.imageLabel.Visible
			end)

			if not visSuccess or not vis then
				self.isPlaying = false
				break
			end

			task.wait(1 / self.config.FPS)

			self.currentFrame = self.currentFrame + 1

			if self.currentFrame > self.config.TOTAL_SPRITES then
				self.currentFrame = 1
			end

			self:updateFrame(self.currentFrame)
		end

		self.isPlaying = false
	end)
end

-- Đặt frame cụ thể
function SpriteAnimator:setFrame(frameIndex)
	if frameIndex >= 1 and frameIndex <= self.config.TOTAL_SPRITES then
		self.currentFrame = frameIndex
		self:updateFrame(self.currentFrame)
	end
end

-- Tự động phát khi visible thay đổi
function SpriteAnimator:autoPlay()
	if not self.imageLabel or not self.imageLabel.Parent then
		warn("ImageLabel không tồn tại!")
		return
	end

	-- Ngắt connection cũ nếu có
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end

	-- Thử connect signal
	local success, err = pcall(function()
		self.connection = self.imageLabel:GetPropertyChangedSignal("Visible"):Connect(function()
			local vis = self.imageLabel.Visible
			if vis then
				self:play()
			else
				self:stop()
			end
		end)
	end)

	if not success then
		warn("Không thể connect Visible signal!")
		warn("Error:", err)
		warn("Object ClassName:", self.imageLabel.ClassName)
		warn("Object Path:", self.imageLabel:GetFullName())
		return
	end

	-- Phát ngay nếu đang visible
	pcall(function()
		if self.imageLabel.Visible then
			self:play()
		end
	end)
end

-- Dọn dẹp
function SpriteAnimator:destroy()
	self:stop()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
	self.imageLabel = nil
end

return SpriteAnimator