# Hyggshi OS Engine – Modules Guide

## What this is

This guide explains what each module does and where to find it. Use it as a quick map of the engine when navigating the codebase.

---

## Quick module map

| Location | File | What it does |
| --- | --- | --- |
| Root | `GUIManager.lua` | Creates, updates, and destroys UI elements. |
| Root | `init.lua` | Boots the engine and loads core modules. |
| `EngineKernel/` | `AppWindow.lua` | Creates and manages app windows and their rendering. |
| `EngineKernel/` | `EngineKernel.lua` | Core kernel: processes, resources, and module coordination. |
| `EngineKernel/` | `GUIManager.lua` | Kernel-level GUI functions: layering and event routing. |
| `EngineKernel/` | `WindowMover.lua` | Drag-to-move window logic and coordinate updates. |
| `EngineKernel/Desktop/` | `Desktop.lua` | Desktop surface: icons, wallpaper, and interactions. |
| `EngineKernel/Taskbar/` | `TaskBar.lua` | Taskbar UI: app shortcuts, running tasks, tray. |
| `ReplicatedStorage/EngineKernel/Desktop/` | `Desktop.lua` | Replicated desktop state for client/server sync. |
| `ReplicatedStorage/EngineKernel/Taskbar/` | `Taskbar.lua` | Replicated taskbar state and events. |
| `StarterPlayer/StarterPlayerScripts/` | `MainClient.luau` | Client bootstrap: input, UI updates, client-only logic. |
| `Utils/` | `ErrorLogger.lua` | Error logging and debug diagnostics. |
| `Utils/` | `test.luau` | Small tests/utilities to verify modules. |

---

## Details by area

### Root

- `GUIManager.lua`: High-level UI helper responsible for creating, updating, and disposing UI elements.
- `init.lua`: Entry point that initializes the engine and loads required modules.

### EngineKernel

- `AppWindow.lua`: Manages the lifecycle of windows (create, focus, minimize, render) inside the OS.
- `EngineKernel.lua`: The kernel’s main coordinator; manages processes, resources, and cross-module messaging.
- `GUIManager.lua`: Kernel-scoped GUI tools, including z-order/layering and routing of UI events.
- `WindowMover.lua`: Implements drag-and-drop mechanics to reposition windows and persist their coordinates.

Submodules:

- `Desktop/Desktop.lua`: Controls the desktop canvas, wallpaper, icon layout, and interactions.
- `Taskbar/TaskBar.lua`: Renders and updates the taskbar with shortcuts, running apps, and system tray items.

### ReplicatedStorage

- `EngineKernel/Desktop/Desktop.lua`: Keeps desktop state synchronized across server and clients.
- `EngineKernel/Taskbar/Taskbar.lua`: Synchronizes taskbar state/events across server and clients.

### StarterPlayer

- `StarterPlayerScripts/MainClient.luau`: Client entry script. Wires user input, applies UI updates, and runs client-only logic.

### Utils

- `ErrorLogger.lua`: Centralized error/exception logging to aid debugging.
- `test.luau`: Lightweight test helpers and sample checks to validate module behavior.

---

## Tips for navigating the code

- Start at `init.lua` to see how the engine boots and which modules load first.
- For UI behavior, read `EngineKernel/GUIManager.lua` and window logic in `AppWindow.lua` and `WindowMover.lua`.
- For multiplayer/client sync concerns, check the equivalents under `ReplicatedStorage/EngineKernel/`.
