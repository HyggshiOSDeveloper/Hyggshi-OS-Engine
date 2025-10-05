-- Utils/ErrorLogger.lua
local ErrorLogger = {}

-- Registry of codes: codeNumber -> {name=..., message=..., level=...}
local Codes = {
    -- Boot (0x01xxxx)
    [0x010001] = { name = "BOOT_MISSING_MODULE", message = "Required boot module not found.", level = "ERROR" },
    [0x010002] = { name = "BOOT_CONFIG_INVALID", message = "Boot config malformed.", level = "FATAL" },

    -- UI (0x02xxxx)
    [0x020001] = { name = "UI_WINDOW_FAIL", message = "Failed to create UI window.", level = "ERROR" },
    [0x020002] = { name = "UI_ASSET_MISSING", message = "UI asset missing.", level = "WARN" },

    -- App (0x03xxxx)
    [0x03000A] = { name = "APP_TIMEOUT", message = "App did not respond in time.", level = "WARN" },
}

-- Helper: format number to 0xHHHHHH
local function fmtHex(n)
    return ("0x%06X"):format(n)
end

-- Basic output function (can replace print with GUI writing or DataStore)
local function output(level, code, name, message, details)
    local prefix = string.format("[%s] %s %s - %s", level, fmtHex(code), name or "-", message or "-")
    if details then
        prefix = prefix .. " | " .. tostring(details)
    end
    if level == "WARN" then
        warn(prefix)
    elseif level == "ERROR" or level == "FATAL" then
        -- error will stop the script if thrown; we only throw for FATAL/ERROR if desired
        -- to allow logging without stopping, use print/warn instead
        print(prefix) -- keep printed; next line can throw if you want
    else
        print(prefix)
    end
end

-- Public: register new codes programmatically (optional)
function ErrorLogger:RegisterCode(codeNumber, name, message, level)
    Codes[codeNumber] = { name = name, message = message, level = level or "ERROR" }
end

-- Public: get code info
function ErrorLogger:GetCodeInfo(codeNumber)
    return Codes[codeNumber]
end

-- Public: log by code (will format, output and optionally throw)
-- options: {throw = true/false, extra = "detail text", showStack = true/false}
function ErrorLogger:LogCode(codeNumber, options)
    options = options or {}
    local info = Codes[codeNumber]
    local name = info and info.name or "UNKNOWN_CODE"
    local message = info and info.message or "Unknown error code."
    local level = info and info.level or "ERROR"

    output(level, codeNumber, name, message, options.extra)

    -- show stack if requested or level severe
    if options.showStack or level == "FATAL" then
        -- capture stack trace
        local trace = debug.traceback("", 2)
        print("Stack Trace:\n" .. trace)
    end

    -- optionally throw error for ERROR/FATAL if options.throw == true
    if options.throw and (level == "ERROR" or level == "FATAL") then
        error(string.format("[%s] %s - %s", fmtHex(codeNumber), name, message), 2)
    end
end

-- Convenience wrappers
function ErrorLogger:Info(msg) print("[INFO] " .. tostring(msg)) end
function ErrorLogger:Warn(msg) warn("[WARN] " .. tostring(msg)) end
function ErrorLogger:Error(msg) error("[ERROR] " .. tostring(msg), 2) end

return ErrorLogger
