# Animation Module Documentation

## Overview

The Animation module provides a comprehensive suite of window animation systems for Hyggshi OS Engine in Roblox. It includes multiple animation styles inspired by different operating systems, sprite-based animations, and creative custom effects.

## Module Structure

```
Animation/
├── Hyggshi_OS_Animation/    # Hyggshi OS signature animations
├── Windows/                  # Windows-style animations
├── MacOS/                    # macOS-style animations
├── Ubuntu/                   # Ubuntu-style animations
├── Custom/                   # Creative custom effects
├── SpriteAnimator/          # Sprite sheet animation system
├── animator4Script.lua      # Example implementation script
└── callanimator.lua         # Example caller script
```

---

## Animation Systems

### 1. Hyggshi OS Animation (`HyggshiAnimator`)

**File**: `Hyggshi_OS_Animation/HyggshiAnimator.lua`

A unique OS style combining smooth curves, gentle bounces, and cozy aesthetics.

#### Features
- **Gentle Bounce**: Signature subtle overshoot effect
- **Soft Glow**: Smooth fade-in/fade-out transitions
- **Float Effect**: Elements float up slightly during animation
- **Rounded Corners**: Automatic corner rounding application

#### Default Settings
```lua
{
    AnimationTime = 0.45,
    StartScale = 0.88,
    StartTransparency = 0.65,
    EasingStyle = Enum.EasingStyle.Exponential,
    EasingDirection = Enum.EasingDirection.Out,
    UseGentleBounce = true,
    UseSoftGlow = true,
    UseFloatIn = true,
    FloatOffset = 15,
    CornerRounding = true
}
```

#### Methods
- `HyggshiAnimator.new(window, customSettings)` - Create new animator
- `:Show()` - Show window with animation
- `:Hide()` - Hide window with animation
- `:CozyMinimize(targetCorner)` - Minimize to corner as rounded bubble
- `:CozyRestore()` - Restore from minimized state
- `:WarmPulse()` - Attention-getting pulse effect
- `:Toggle()` - Toggle visibility
- `:UpdateSettings(newSettings)` - Update animation settings

#### Example Usage
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HyggshiAnimator = require(ReplicatedStorage.Hyggshi_OS_Animation)

local window = script.Parent:WaitForChild("MainWindow")
local animator = HyggshiAnimator.new(window)

animator:Show()
-- Later...
animator:Hide()
```

---

### 2. Windows Animator (`WindowAnimator`)

**File**: `Windows/WindowsAnimator.lua`

Windows-style animations with quick, snappy transitions.

#### Features
- **Slide Down**: Windows slides down slightly on open
- **Fast Transitions**: Quick, responsive animations (0.25s default)
- **Optional Bounce**: Windows 11-style subtle bounce
- **Minimize to Taskbar**: Animate to bottom of screen

#### Default Settings
```lua
{
    AnimationTime = 0.25,
    StartScale = 0.95,
    StartTransparency = 1.0,
    EasingStyle = Enum.EasingStyle.Sine,
    EasingDirection = Enum.EasingDirection.Out,
    UseSlideDown = true,
    SlideOffset = -20,
    UseBounce = false
}
```

#### Methods
- `WindowAnimator.new(window, customSettings)`
- `:Show()`
- `:Hide()`
- `:Minimize(targetPosition)` - Minimize to taskbar
- `:Toggle()`
- `:UpdateSettings(newSettings)`

---

### 3. macOS Animator (`macOS`)

**File**: `MacOS/MacOS.lua`

macOS-style animations with smooth, elegant transitions.

#### Features
- **Smooth Scaling**: Elegant zoom from center
- **Quart Easing**: Characteristic macOS easing curve
- **Balanced Timing**: 0.3s animations for polish

#### Default Settings
```lua
{
    AnimationTime = 0.3,
    StartScale = 0.7,
    StartTransparency = 0.5,
    EasingStyle = Enum.EasingStyle.Quart,
    EasingDirection = Enum.EasingDirection.Out
}
```

#### Methods
- `macOS.new(window, customSettings)`
- `:Show()`
- `:Hide()`
- `:Toggle()`
- `:UpdateSettings(newSettings)`

---

### 4. Ubuntu Animator (`UbuntuAnimator`)

**File**: `Ubuntu/UbuntuAnimator.lua`

Ubuntu-style animations with signature zoom and bounce effects.

#### Features
- **Back Easing**: Ubuntu's signature overshoot effect
- **Zoom from Center**: Characteristic Ubuntu window opening
- **Elastic Bounce**: Optional wobbly effect
- **Workspace Switch**: Slide animation between workspaces
- **Magic Lamp**: Fun minimize animation

#### Default Settings
```lua
{
    AnimationTime = 0.28,
    StartScale = 0.85,
    StartTransparency = 0.8,
    EasingStyle = Enum.EasingStyle.Back,
    EasingDirection = Enum.EasingDirection.Out,
    UseZoomEffect = true,
    UseElasticBounce = false,
    FadeDelay = 0.05
}
```

#### Methods
- `UbuntuAnimator.new(window, customSettings)`
- `:Show()`
- `:Hide()`
- `:WorkspaceSwitch(direction)` - Slide animation ("left", "right", "up", "down")
- `:MagicLamp(targetPosition)` - Genie-style minimize effect
- `:Toggle()`
- `:UpdateSettings(newSettings)`

---

### 5. Custom Effects (`Custom`)

**File**: `Custom/Custom.lua`

Creative and experimental animation effects for unique visual experiences.

#### Available Effects

| Effect | Description |
|--------|-------------|
| `portal` | Spiraling portal entrance with rotation |
| `shatter` | Glass shatter from center with pulses |
| `origami` | Paper folding effect (unfold vertical then horizontal) |
| `liquid` | Liquid drop splash with elastic bounce |
| `hologram` | Sci-fi hologram flicker effect |
| `smoke` | Smoke dissipation/condensation |
| `neon_pulse` | Cyberpunk neon glow burst |
| `dreamscape` | Surreal wavy entrance with rotation |
| `retro_tv` | Old CRT TV switch-on (expand width then height) |
| `quantum_snap` | Quantum jitter then snap into place |

#### Example Usage
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Custom = require(ReplicatedStorage.Custom)

local window = script.Parent:WaitForChild("MainWindow")

-- Using quantum_snap effect
local animator = Custom.new(window, "quantum_snap")
animator:Show()

-- Using portal effect
local animator2 = Custom.new(window, Custom.Effects.PORTAL)
animator2:Show()
```

#### Methods
- `Custom.new(window, effect)` - Create animator with specific effect
- `:Show()` - Show with selected effect
- `:Hide()` - Hide with fade and shrink
- `:Toggle()`

---

### 6. Sprite Animator (`SpriteAnimator`)

**File**: `SpriteAnimator/SpriteAnimator.lua`

Frame-based sprite sheet animation system for GUI elements.

#### Features
- **Sprite Sheet Support**: Animate through sprite sheet frames
- **Configurable FPS**: Control animation speed
- **Auto-play**: Automatically play when visible
- **Pause/Resume**: Full playback control
- **Frame Control**: Jump to specific frames

#### Configuration
```lua
{
    FPS = 60,                          -- Frames per second
    SPRITE_SIZE = Vector2.new(64, 64), -- Size of each sprite
    TOTAL_SPRITES = 119,               -- Total number of frames
    SPRITES_PER_ROW = 15              -- Sprites per row in sheet
}
```

#### Methods
- `SpriteAnimator.new(imageLabel, config)` - Create animator
- `:play()` - Start animation from beginning
- `:stop()` - Stop and reset animation
- `:pause()` - Pause at current frame
- `:resume()` - Resume from current frame
- `:setFrame(frameIndex)` - Jump to specific frame
- `:autoPlay()` - Auto-play when visible changes
- `:destroy()` - Clean up resources

#### Example Usage
```lua
local SpriteAnimator = require(ReplicatedStorage.SpriteAnimator)

local imageLabel = script.Parent:WaitForChild("LoadingSprite")

local animator = SpriteAnimator.new(imageLabel, {
    FPS = 30,
    SPRITE_SIZE = Vector2.new(64, 64),
    TOTAL_SPRITES = 119,
    SPRITES_PER_ROW = 15
})

-- Auto-play when visible
animator:autoPlay()

-- Or manual control
animator:play()
task.wait(2)
animator:pause()
```

---

## Common Usage Patterns

### Basic Window Animation

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WindowAnimator = require(ReplicatedStorage.Windows)

local window = script.Parent:WaitForChild("MainWindow")
local animator = WindowAnimator.new(window)

-- Connect to buttons
local openButton = script.Parent:FindFirstChild("OpenButton")
local closeButton = window:FindFirstChild("CloseButton")

if openButton then
    openButton.MouseButton1Click:Connect(function()
        animator:Show()
    end)
end

if closeButton then
    closeButton.MouseButton1Click:Connect(function()
        animator:Hide()
    end)
end
```

### Custom Settings

```lua
local animator = HyggshiAnimator.new(window, {
    AnimationTime = 0.6,
    UseGentleBounce = false,
    StartScale = 0.9
})
```

### Dynamic Settings Update

```lua
local animator = WindowAnimator.new(window)

-- Later, update settings
animator:UpdateSettings({
    AnimationTime = 0.5,
    UseBounce = true
})
```

---

## Technical Details

### Transparency Management

All animators automatically store and restore transparency values for:
- **BackgroundTransparency** - All GuiObjects
- **TextTransparency** - TextLabel, TextButton, TextBox
- **ImageTransparency** - ImageLabel, ImageButton

This ensures smooth fade-in/fade-out effects while preserving original transparency settings.

### Position Handling

- **Hyggshi, macOS, Ubuntu**: Store original position for restore operations
- **Windows**: Uses AnchorPoint for centered scaling without position storage
- **Custom**: Varies by effect type

### TweenService Integration

All animations use Roblox's `TweenService` for smooth, performant transitions. Tweens are properly chained using `Completed` events for multi-stage animations.

---

## Best Practices

1. **Choose the Right Animator**: Match the animation style to your OS theme
2. **Consistent Timing**: Use similar animation times across your UI for cohesion
3. **Test Performance**: Sprite animations with high FPS may impact performance
4. **Clean Up**: Call `:destroy()` on SpriteAnimator when done
5. **Anchor Points**: Ensure windows have proper AnchorPoint settings for centered animations
6. **Custom Effects**: Use sparingly for special moments, not every window

---

## Performance Considerations

- **Sprite Animations**: Higher FPS = more CPU usage
- **Custom Effects**: Some effects (hologram, glitch) use multiple concurrent tweens
- **Transparency Tweens**: Animating many descendants can be expensive
- **Auto-play**: SpriteAnimator's auto-play uses property change signals efficiently

---

## Version History

- **v1.3**: Added Custom effects module with 10+ creative animations
- **v1.2**: Added SpriteAnimator for frame-based animations
- **v1.1**: Added Ubuntu, macOS, and Windows animators
- **v1.0**: Initial release with HyggshiAnimator

---

## License

Part of Hyggshi OS Engine. See main project license for details.
