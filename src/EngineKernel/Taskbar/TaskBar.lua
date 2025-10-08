function Taskbar:AddAppButton(appName, appWindow)
	if not self.Gui then
		warn("[Taskbar] Not initialized yet.")
		return
	end

	local button = Instance.new("ImageButton")
	button.Name = appName .. "rbxassetid://135303389500761"
	button.Position = UDim2.new(0.047, 0, 0.026, 0)
	button.Size = UDim2.new(0.02, 0, 0.974, 0)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 14
	button.Text = appName
	button.ZIndex = 11
	button.Parent = self.Gui

	self.Buttons[appName] = { Button = button, Window = appWindow }

	button.MouseButton1Click:Connect(function()
		if appWindow.Gui.Visible then
			appWindow.Gui.Visible = false
		else
			appWindow.Gui.Visible = true
			appWindow.Gui.ZIndex = 20
		end
	end)

	print("[Taskbar] Added app button:", appName)
end

return Taskbar
