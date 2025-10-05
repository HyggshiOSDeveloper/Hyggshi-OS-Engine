-- Please Use Classic Script Style

local Logger = require(game.ServerScriptService.Utils.ErrorLogger)

Logger:LogCode(0x010001, { extra = "Hyggshi kernel.lua missing", showStack = false })

Logger:LogCode(0x010002, { extra = "invalid JSON in boot.cfg", showStack = true })

Logger:RegisterCode(0x050001, "DS_WRITE_FAIL", "Failed to write to DataStore.", "ERROR")
Logger:LogCode(0x050001, { extra = "Key=user_123", throw = false })
