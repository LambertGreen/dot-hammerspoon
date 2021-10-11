-- My Hammerspoon config

-- Set the global log level
hs.logger.defaultLogLevel = "info"

-- Install Spoons with SpoonInstall
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

require('HyperMode')
require('ConfigWatcher')
require('ControlTapToEscape')
-- TODO Add keybinding in HyperMode for ShowKeys functionality
require('ShowKeys')
require('AppWatcher')
require('AppSwitcher')
require('Readline')

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
