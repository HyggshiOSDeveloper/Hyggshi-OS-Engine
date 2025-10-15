local HyggshiAPI = require(game.ReplicatedStorage.EngineKernel.WindowAPI.HyggshiAPI)

local MyApp = {}
MyApp.Name = "XP Tour"
MyApp.Icon = "rbxassetid://18647100139"

MyApp.OnLaunch = function()
	HyggshiAPI.MessageBox(MyApp.Name, "Chào mừng bạn đến với XP Tour của Hyggshi OS!", MyApp.Icon)
end

MyApp.OnLaunch()
