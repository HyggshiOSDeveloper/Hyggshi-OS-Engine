-- 🔵 BSOD.lua
local BSOD = {}

function BSOD:ShowError(title, message)
	local player = game.Players.LocalPlayer
	if not player then
		warn("[BSOD] No LocalPlayer found, cannot display GUI.")
		return
	end

	local playerGui = player:FindFirstChildOfClass("PlayerGui")
	if not playerGui then
		playerGui = Instance.new("ScreenGui")
		playerGui.Name = "TempPlayerGui"
		playerGui.ResetOnSpawn = false
		playerGui.IgnoreGuiInset = true
		playerGui.Parent = player:WaitForChild("PlayerGui", 1) or player
	end

	local old = playerGui:FindFirstChild("BSODScreen")
	if old then old:Destroy() end

	local screen = Instance.new("ScreenGui")
	screen.Name = "BSODScreen"
	screen.IgnoreGuiInset = true
	screen.ResetOnSpawn = false
	screen.DisplayOrder = 999999
	screen.Parent = playerGui

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 180)
	bg.BorderSizePixel = 0
	bg.Parent = screen

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -40, 0, 60)
	titleLabel.Position = UDim2.new(0, 20, 0, 20)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.TextSize = 38
	titleLabel.Text = title or "FATAL ERROR"
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = bg

    local msgLabel = Instance.new("TextLabel")
	msgLabel.Size = UDim2.new(1, -40, 1, -100)
	msgLabel.Position = UDim2.new(0, 20, 0, 100)
	msgLabel.BackgroundTransparency = 1
	msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	msgLabel.Font = Enum.Font.SourceSans
	msgLabel.TextSize = 22
	msgLabel.TextWrapped = true
	msgLabel.TextXAlignment = Enum.TextXAlignment.Left
	msgLabel.TextYAlignment = Enum.TextYAlignment.Top
	msgLabel.Text = message or "An unexpected error occurred.\nPlease restart the game."
	msgLabel.Parent = bg

	print("[BSOD] Displayed error screen: " .. (title or "Unknown Error"))
end

return BSOD
