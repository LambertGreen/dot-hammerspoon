-- My Hammerspoon config

-- Set the global log level
hs.logger.defaultLogLevel = "info"

-- Enable IPC for CLI access
hs.ipc.cliInstall()

-- Install Spoons with SpoonInstall
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

-- Enable ControlTapToEscape with toggle functionality first
controlToEscape = require('ControlTapToEscape')

require('HyperMode')
require('ConfigWatcher')
-- TODO Add keybinding in HyperMode for ShowKeys functionality
require('ShowKeys')
require('AppWatcher')
require('SafeQuit')
require('hide-covered-windows')
require('WindowDragging')

-- Disable the ~Alt+Tab~ switcher as we want to keep the key combo for remote desktop
-- require('AppSwitcher')

-- Alert whenever this config is loaded.
hs.alert.show("Hammerspoon: config loaded")

-- Disabled packages
--
-- Hammersoon is no longer working with good performance as the registered browser
-- require('UrlRouter')
--
-- No longer using ShiftToBrackets because it is better to learn to touch type the brackets after all.
-- An issue with using it, was that often times I pressed Shift by mistake which resulted in spurious
-- brackets being inputted.  This was especially annoying in password input fields.
-- require('ShiftToBrackets')

-- Disabling the use of UrlRouter for the following reasons:
-- 1. It does not work when trying to use 2 Chrome profiles
-- 2. It does not work when trying to use 2 browsers i.e. Chrome and Chrome Beta
-- require('UrlRouter')

-- Disabling the Readline since the only thing
-- there is an attempt to add <ctrl-u> functionality,
-- and we are running into issues with that.
-- Fortunately macOS already has decent support
-- for Readline like bindings.
--
-- require('Readline')
