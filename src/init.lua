-- init.lua
-- Please Use ModuleScript type

local Engine = {}

local Boot = require(script.Core.Boot)
local UIManager = require(script.Core.UIManager)

function Engine:Boot(osName)
	print(osName .. " is starting...")
	Boot:Init()
	UIManager:Init()
end

function Engine:Shutdown()
	print("Shutting down Hyggshi OS Engine...")
end

return Engine
