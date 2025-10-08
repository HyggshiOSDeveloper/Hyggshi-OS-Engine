local GUIManager = {}
GUIManager.Layers = {}

function GUIManager:Init()
	print("[GUIManager] Initialized successfully.")
end

function GUIManager:Register(gui, layer)
	layer = layer or 1
	self.Layers[gui] = layer
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.ZIndex = layer
end

function GUIManager:SetOnTop(gui)
	local top = 0
	for _, l in pairs(self.Layers) do
		if l > top then top = l end
	end
	self.Layers[gui] = top + 1
	gui.ZIndex = top + 1
end

return GUIManager
