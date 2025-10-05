-- Please Use LocalScript type

local DesktopGui = Instance.new('ScreenGui')
DesktopGui.Name = 'DesktopGui'
DesktopGui.Enabled = true
DesktopGui.IgnoreGuiInset = true
DesktopGui.Parent = game.Players.LocalPlayer:WaitForChild('PlayerGui')

local ImageBackground = Instance.new('ImageLabel')
ImageBackground.Name = 'ImageBackground'
ImageBackground.Size = UDim2.new(1, 0, 1, 0)
ImageBackground.Position = UDim2.new(-0.001, 0, 0, 0)
ImageBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageBackground.Image = "rbxassetid://129548761614383"
ImageBackground.Visible = true
ImageBackground.ZIndex = 1
ImageBackground.Parent = DesktopGui
