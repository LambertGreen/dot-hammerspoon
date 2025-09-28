# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Hammerspoon configuration for macOS automation and window management. Hammerspoon uses Lua for scripting and provides APIs to interact with macOS applications, windows, keyboard events, and system features.

## Architecture

### Entry Point
- `init.lua` - Main config file that loads all modules. After changes, Hammerspoon shows an alert "Hammerspoon: config loaded"

### Module Loading Pattern
All modules are loaded via `require()` and typically return a table of functions or use global registration (hotkeys, watchers). Modules are standalone `.lua` files in the root directory.

### Key Modules

**HyperMode** (`HyperMode.lua`)
- Implements a modal keyboard system using RecursiveBinder Spoon
- Hyper key: Ctrl+Cmd+Space
- Creates nested keybinding menus for window management, app switching, mission control, etc.
- Depends on: WindowManagement, MousePointer, Application, MissionControl modules

**ControlTapToEscape** (`ControlTapToEscape.lua`)
- Maps Control key tap (press and release with no other keys) to Escape
- Uses `hs.eventtap` to intercept keyboard events
- Has app exclusion filters for VMs and remote desktop apps (VirtualBox, Parallels, Screen Sharing, etc.)
- Special workaround for NoMachine due to bad window behavior
- Starts disabled by default, toggleable via HyperMode (Ctrl+Cmd+Space → t)

**WindowManagement** (`WindowManagement.lua`)
- Delegates actual window positioning to Divvy (third-party app)
- Functions send keystroke events to trigger Divvy's hotkeys (Ctrl+Cmd+Alt + hjkliunmfd)
- Also includes custom CMD+Alt+H: hide windows covered by frontmost window (screen and space aware)

**ConfigWatcher** (`ConfigWatcher.lua`)
- Auto-reloads Hammerspoon when `.lua` files change
- Watches both `~/.hammerspoon/` and `~/dev/my/dotfiles/hammerspoon/` (handles symlink setup)

**SafeQuit** (`SafeQuit.lua`)
- Overrides CMD+Q to require double-press within 1.5 seconds
- Prevents accidental application quits

**ShowKeys** (`ShowKeys.lua`)
- Toggle with Ctrl+Cmd+Shift+P
- Displays on-screen popup showing pressed keys (useful for demos/screencasts)

### Spoons
Spoons are Hammerspoon plugins/libraries installed in `Spoons/` directory:
- **SpoonInstall** - Package manager for Spoons
- **RecursiveBinder** - Enables nested/modal keybindings used by HyperMode

## Development Workflow

### Testing Changes
1. Save `.lua` file - ConfigWatcher will auto-reload
2. Watch for "Hammerspoon: config loaded" alert
3. Check Hammerspoon Console (Hyper → c → o) for errors

### Accessing Hammerspoon Console
- Open: Ctrl+Cmd+Space → c → o
- Close: Ctrl+Cmd+Space → c → c
- Console shows logs from `hs.logger` instances (set levels with `hs.logger.defaultLogLevel`)

### No Build/Test Commands
Hammerspoon config has no build, lint, or test pipeline. Testing is manual via reload and usage.

## Important Patterns

### Module Structure
```lua
local obj = {}
obj.someFunction = function() ... end
return obj
```

### Event Watchers
Many modules use `hs.eventtap`, `hs.window.filter`, or `hs.pathwatcher` to monitor system events. These must be started with `:start()` and can be stopped with `:stop()`.

### Application Exclusions
ControlTapToEscape uses `hs.window.filter` with both exclusion and inclusion filters. When adding remote desktop or VM apps, add to both filters.

## Disabled/Deprecated Modules

Several modules are kept but not loaded in `init.lua`:
- AppSwitcher - Conflicts with remote desktop Alt+Tab
- UrlRouter - Doesn't work well with multiple Chrome profiles
- ShiftToBrackets - User decided to learn proper touch typing
- Readline - macOS has built-in readline bindings

These remain in the repo for reference but are commented out in `init.lua`.

## File Locations

The actual Hammerspoon config lives in `~/.hammerspoon/` but this repo is located at `~/dev/my/dotfiles/configs/hammerspoon/dot-hammerspoon/` and is symlinked. ConfigWatcher monitors both locations.