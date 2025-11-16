local TweenService = game:GetService("TweenService")
local menu = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Start_Menu"):WaitForChild("StartMenuFrame")

local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

menu.BackgroundTransparency = 1
menu.Visible = false

local isOpen = false

local module = {}

-- Function to tween all child elements (fade in/out)
local function fadeDescendants(parent, targetTransparency)
	for _, v in ipairs(parent:GetDescendants()) do
		if v:IsA("ImageLabel") or v:IsA("ImageButton") then
			TweenService:Create(v, tweenInfo, {ImageTransparency = targetTransparency}):Play()
		elseif v:IsA("TextLabel") or v:IsA("TextButton") then
			TweenService:Create(v, tweenInfo, {TextTransparency = targetTransparency}):Play()
		elseif v:IsA("Frame") then
			TweenService:Create(v, tweenInfo, {BackgroundTransparency = targetTransparency}):Play()
		end
	end
end

function module.Toggle()
	if isOpen then
		module.Close()
	else
		module.Open()
	end
end

function module.Open()
	if not isOpen then
		menu.Visible = true
		-- Fade in the entire menu and child elements
		TweenService:Create(menu, tweenInfo, {BackgroundTransparency = 0.75}):Play()
		fadeDescendants(menu, 0)
		isOpen = true
	end
end

function module.Close()
	if isOpen then
		-- Fade out all menu and child elements
		local tween = TweenService:Create(menu, tweenInfo, {BackgroundTransparency = 1})
		fadeDescendants(menu, 1)
		tween:Play()
		tween.Completed:Connect(function()
			menu.Visible = false
		end)
		isOpen = false
	end
end

function module.IsOpen()
	return isOpen
end

return module
