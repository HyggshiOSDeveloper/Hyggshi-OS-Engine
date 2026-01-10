local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ResponsiveGrid = require(ReplicatedStorage.Hyggshi_OS_Engine
	:WaitForChild("src")
	:WaitForChild("AutoUIGridLayout")
	:WaitForChild("ResponsiveGrid"))

-- Get your UIGridLayout
local gridLayout = script.Parent.UIGridLayout

-- Create responsive grid with defaults
local responsiveGrid = ResponsiveGrid.new(gridLayout, {
	Mobile = {
		CellSize = UDim2.new(0, 25, 0, 25),
		CellPadding = UDim2.new(0, 4, 0, 4)
	},
	Laptop = {
		CellSize = UDim2.new(0, 45, 0, 45),
		CellPadding = UDim2.new(0, 10, 0, 10)
	},
	
	Tablet = {
		CellSize = UDim2.new(0, 50, 0, 50),
		CellPadding = UDim2.new(0, 10, 0, 10)
	},
	
	Desktop = {
		CellSize = UDim2.new(0, 60, 0, 60),
		CellPadding = UDim2.new(0, 10, 0, 10)
	}
})
