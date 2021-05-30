-- Provides Mission Control keybind access
--
-- Note: This relies on specific keybindings that need to be set
-- in System Preferences -> Keyboard -> Shortcuts: MissionControl
-- 
local obj = {}

local hyperMod = {'ctrl', 'shift', 'alt', 'cmd'}

-- Note: simply using 'ctrl+left' was not working and the below workaround was found:
-- https://github.com/Hammerspoon/hammerspoon/issues/1946
local missionControlDefaultMod = {'fn', 'ctrl'}

obj.toggleNotificationCenter = function() hs.eventtap.keyStroke(hyperMod, 'n') end
obj.toggleDoNotDisturb = function() hs.eventtap.keyStroke(hyperMod, 'd') end

obj.showMissionControl = function() hs.eventtap.keyStroke(missionControlDefaultMod, 'up') end
obj.showApplications = function() hs.eventtap.keyStroke(missionControlDefaultMod, 'down') end
obj.moveLeftSpace = function() hs.eventtap.keyStroke(missionControlDefaultMod, 'left') end
obj.moveRightSpace = function() hs.eventtap.keyStroke(missionControlDefaultMod, 'right') end

return obj
