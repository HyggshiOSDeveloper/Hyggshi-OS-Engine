# Hyggshi OS Engine Documentation

## Overview

This documentation provides an overview and description of each module in the `src` folder of the Hyggshi OS Engine project.

---

## Root Modules

### GUIManager.lua

Manages graphical user interface components, including creation, updating, and destruction of UI elements.

### init.lua

Initializes the engine, loading core modules and setting up the environment for the OS engine to run.

---

## EngineKernel

### AppWindow.lua

Handles application window creation, management, and rendering within the OS environment.

### EngineKernel.lua

Core kernel logic for the engine, managing system processes, resources, and communication between modules.

### GUIManager.lua

Provides GUI management functions specific to the kernel, including window layering and event handling.

### WindowMover.lua

Enables moving and repositioning of windows by handling drag-and-drop events and updating window coordinates.

#### Desktop

##### Desktop.lua

Manages the desktop environment, including icon placement, wallpaper settings, and desktop interactions.

#### Taskbar

##### TaskBar.lua

Implements the taskbar, handling application shortcuts, running tasks, and system tray functionality.

---

## ReplicatedStorage

### EngineKernel

#### Desktop

##### Desktop.lua

Provides replicated desktop logic for client-server synchronization, ensuring consistent desktop state across clients.

#### Taskbar

##### Taskbar.lua

Handles replicated taskbar state and events, synchronizing running applications and shortcuts between server and clients.

---

## StarterPlayer

### StarterPlayerScripts

#### MainClient.luau

Main client-side script for initializing and managing user interactions, UI updates, and client-specific logic.

---

## Utils

### ErrorLogger.lua

Logs errors and exceptions, providing debugging information and error tracking for the engine.

### test.luau

Contains test scripts and utilities for verifying module functionality and engine stability.
