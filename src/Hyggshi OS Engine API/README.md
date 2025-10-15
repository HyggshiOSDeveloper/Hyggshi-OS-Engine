# Hyggshi OS Engine — API (English)

![Hyggshi OS Engine API](assets/HyggshiOSEngineAPI.png)

This folder contains the client-facing API for the Hyggshi OS Engine. It exposes utility functions and window-management helpers that client scripts can require to create, open, move, and control windows and UI elements provided by the engine.

## Overview

The API is a lightweight wrapper around the engine internals that is intended to be placed in a shared location (for example, ReplicatedStorage) so client scripts can require it. It simplifies common tasks such as creating application windows, controlling focus, and listening for window events.

## Installation

1. Copy the `src` folder from this module into your Roblox project. A recommended location is:
   - `ReplicatedStorage["Hyggshi OS Engine API"]` or
   - `ReplicatedStorage.HyggshiOSAPI`
2. Ensure the engine runtime (EngineKernel, Desktop, Taskbar, etc.) is present in the expected locations in the project so the API can communicate with the core.

## Usage (example)

Client script example (LocalScript inside StarterPlayerScripts or StarterGui):

```lua
-- Example: require the API (adjust path to where you placed the API in ReplicatedStorage)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local apiFolder = ReplicatedStorage:WaitForChild("Hyggshi OS Engine API")
local HyggshiAPI = require(apiFolder.src.WindowAPI.HyggshiAPI)

-- Create or open a window (example, actual function names and parameters may vary)
local window = HyggshiAPI:CreateWindow({
    id = "MyApp",
    title = "My Application",
    size = Vector2.new(400, 300),
    position = Vector2.new(100, 100)
})

-- Listen for events
HyggshiAPI.OnWindowClosed:Connect(function(windowId)
    print("Window closed:", windowId)
end)
```

Note: Inspect `WindowAPI/HyggshiAPI.lua` to confirm exact function names and parameter signatures.

## API Surface (high-level)

The API typically provides:
- Window creation and destruction helpers
- Open / close / toggle window functions
- Move, resize, and focus helpers
- Event signals for window opened, closed, focused, moved, resized
- Convenience helpers to register applications or shortcuts with the taskbar/desktop

Refer to `WindowAPI/HyggshiAPI.lua` for the definitive list of functions and events exported by the module.

## Contributing

- Verify any changes against the engine's `EngineKernel` and `ReplicatedStorage` integration.
- Keep public API backwards-compatible where possible; bump version or document breaking changes.

## License

Include your project license here (e.g., MIT) or remove this section if using a different license.

## Where to look next

- Engine kernel and runtime: `EngineKernel/`
- Window API implementation: `WindowAPI/HyggshiAPI.lua`
- Example client usage: `src/StarterGui/LocalScript.lua`