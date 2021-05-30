-- Implements a Hyper modal mode
--

hs.loadSpoon("RecursiveBinder")
key = spoon.RecursiveBinder.singleKey

local wm = require('WindowManagement')
local mouse = require('MousePointer')
local app = require('Application')
local mc = require('MissionControl')

local hyperMod = {'ctrl', 'command'}
local hyperKey = 'Space'

windowMove = {}
windowMove[key("h", "left")] = wm.moveWindowLeft
windowMove[key("j", "bottom")] = wm.moveWindowDown
windowMove[key("k", "top")] = wm.moveWindowUp
windowMove[key("l", "right")] = wm.moveWindowRight
windowMove[key("u", "top-left")] = wm.moveWindowTopLeft
windowMove[key("i", "top-right")] = wm.moveWindowTopRight
windowMove[key("n", "bottom-left")] = wm.moveWindowBottomLeft
windowMove[key("m", "bottom-right")] = wm.moveWindowBottomRight
windowMove[key("d", "center")] = wm.moveWindowCenter
windowMove[key("f", "maximize")] = wm.moveWindowMaximize

hsConsole = {}
hsConsole[key("o", "open")] = hs.openConsole
hsConsole[key("c", "close")] = hs.closeConsole
-- hsConsole[key("t", "toggle OnTop")] = hs.consoleOnTop

missionControl = {}
missionControl[key("n", "toggle-notifications")] = mc.toggleNotificationCenter
missionControl[key("d", "toggle-dnd")] = mc.toggleDoNotDisturb
missionControl[key("k", "show-mission-control")] = mc.showMissionControl
missionControl[key("j", "show-applications")] = mc.showApplications
missionControl[key("h", "left-space")] = mc.moveLeftSpace
missionControl[key("l", "right-space")] = mc.moveRightSpace

hyper = {}
hyper[key("w", "manage windows")] = windowMove
hyper[key("s", "switcher")] = hs.hints.windowHints
hyper[key("q", "kill app")] = app.appKill9
hyper[key("p", "move mouse")] = mouse.movePointerToOtherScreen
hyper[key("c", "console")] = hsConsole
hyper[key("m", "mission-control")] = missionControl

hs.hotkey.bind(hyperMod, hyperKey, spoon.RecursiveBinder.recursiveBind(hyper))
