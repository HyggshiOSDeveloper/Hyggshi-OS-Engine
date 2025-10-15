local HyggshiAPI = {}

function HyggshiAPI.CreateWindow(title, width, height, icon)
	local Player = game.Players.LocalPlayer
	local PlayerGui = Player:WaitForChild("PlayerGui")

	local ScreenGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local TitleBar = Instance.new("TextLabel")
	local Icon = Instance.new("ImageLabel")

	Frame.Name = title .. "_Window"
	Frame.Size = UDim2.new(0, width, 0, height)
	Frame.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
	Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Frame.Active = true
	Frame.Draggable = false
	Frame.Parent = ScreenGui

	Icon.Name = "Icon"
	Icon.Image = icon or "rbxassetid://0"
	Icon.Position = UDim2.new(0, 4, 0, 2)
	Icon.Size = UDim2.new(0, 20, 0, 20)
	Icon.BackgroundTransparency = 1
	Icon.Parent = Frame

	TitleBar.Text = title
	TitleBar.Size = UDim2.new(1, -28, 0, 24)
	TitleBar.Position = UDim2.new(0, 28, 0, 0)
	TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleBar.TextXAlignment = Enum.TextXAlignment.Left
	TitleBar.Font = Enum.Font.SourceSansBold
	TitleBar.TextSize = 18
	TitleBar.Parent = Frame

	ScreenGui.Parent = PlayerGui

	HyggshiAPI.EnableWindowMove(Frame, TitleBar)

	return Frame
end

function HyggshiAPI.EnableWindowMove(windowFrame, dragArea)
	local dragging = false
	local dragStart = nil
	local startPos = nil
	local UserInputService = game:GetService("UserInputService")

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = windowFrame.Position
		end
	end)

	dragArea.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart
			windowFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

function HyggshiAPI.MessageBox(title, message, icon)
	local window = HyggshiAPI.CreateWindow(title, 300, 150, icon)
	local msg = Instance.new("TextLabel")
	msg.Text = message
	msg.Size = UDim2.new(1, -20, 1, -40)
	msg.Position = UDim2.new(0, 10, 0, 30)
	msg.TextWrapped = true
	msg.BackgroundTransparency = 1
	msg.TextColor3 = Color3.new(1, 1, 1)
	msg.Font = Enum.Font.SourceSans
	msg.TextSize = 18
	msg.Parent = window
end

return HyggshiAPI
