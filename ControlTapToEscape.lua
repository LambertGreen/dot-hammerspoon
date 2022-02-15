-- Makes the Control key double up as an Escape key.
-- Works well together with mapping the Capslock key to Control key.
--    Capslock can be mapped to Control using OS Preferences or Karabiner Elements.
--
-- From: https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f

local log = hs.logger.new('CtrlToEscape')
local send_escape = false
local prev_modifiers = {}
local is_enabled = false
local obj = {}

len = function(t)
    local length = 0
    for _ in pairs(t) do
        length = length + 1
    end
    return length
end

empty = function(t)
    if next(t) == nil then
        return true
    end
    return false
end

on_control_down = function(evt)
    -- On ctrl down check if we should convert to an escape
    local curr_modifiers = evt:getFlags()

    if curr_modifiers["ctrl"] and len(curr_modifiers) == 1 and empty(prev_modifiers) then
        send_escape = true
    elseif send_escape and prev_modifiers["ctrl"] and empty(curr_modifiers) then
        hs.eventtap.event.newKeyEvent({}, 'escape', true):post()
        hs.eventtap.event.newKeyEvent({}, 'escape', false):post()
        send_escape = false
        log.d('Control tapped: sent escape key.')
    else
        send_escape = false
    end

    prev_modifiers = curr_modifiers
    return true
end

on_non_modifier_down = function(evt)
    -- If any non-modifier key is pressed, we know we won't be sending an escape
    send_escape = false
    return false
end

enable = function()
    ctrl_to_escape_modifier_tap:start()
    ctrl_to_escape_non_modifier_tap:start()
    is_enabled = true
    log.d("ControlToEscape: enabled")
end

disable = function()
    ctrl_to_escape_modifier_tap:stop()
    ctrl_to_escape_non_modifier_tap:stop()
    is_enabled = false
    send_escape = false
    log.d("ControlToEscape: disabled")
end

obj.toggle = function()
    if is_enabled then
        disable()
    else
        enable()
    end
end

ctrl_to_escape_modifier_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, on_control_down)
ctrl_to_escape_non_modifier_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, on_non_modifier_down)

-- Setup a excluded application filter
exclusionFilter = hs.window.filter.new({
    ['VirtualBox VM'] = {activeApplication=true},
    ['Screen Sharing'] = {activeApplication=true},
    ['Microsoft Remote Desktop'] = {activeApplication=true},
    ['Windows 11'] = {activeApplication=true},
    ['Paralles Desktop'] = {activeApplication=true},
    ['Geforce Now'] = {activeApplication=true},
    Remotix = {activeApplication=true},
    NoMachine = {activeApplication=true},
    default = false
})

-- NoMachine workaround:
-- Unfortunately due to NoMachine bad app/window behavior we
-- need to maintain an 'inclusion' filter that is the opposite
-- of the exlusion filter
inclusionFilter = hs.window.filter.new({
    ['VirtualBox VM'] = {activeApplication=false},
    ['Screen Sharing'] = {activeApplication=false},
    ['Microsoft Remote Desktop'] = {activeApplication=false},
    ['Windows 11'] = {activeApplication=false},
    ['Paralles Desktop'] = {activeApplication=false},
    ['Geforce Now'] = {activeApplication=false},
    Remotix = {activeApplication=false},
    NoMachine = {activeApplication=false},
    default = true
})

local isNoMachineActivated = false

on_exclusion_activated = function(w, appName, event)
    log.df("Disabling ControlToEscape: %s", appName)
    if appName == "NoMachine" then
        isNoMachineActivated = true
    end
    disable()
end

on_exclusion_deactivated = function(w, appName, event)
    if appName == "NoMachine" then
        log.df("NoMachine workaround: don't enable ControlToEscape")
    else
        log.df("Enabling ControlToEscape: %s", appName)
        enable()
    end
end

on_inclusion_activated = function(w, appName, event)
-- Workaround for NoMachine:
-- Ignore event if from NoMachine, and otherwise enable ControlToEscape
    if appName == "NoMachine" then
        log.df("NoMachine workaround: ignore event")
    else
        if isNoMachineActivated then
            log.df("NoMachine workaround (%s): enable ControlToEscape", appName)
            isNoMachineActivated = false
            enable()
        end
    end
end

local activateEvents = {
  'windowCreated',
  'windowFocused',
  'windowOnScreen',
  'windowVisible',
  'windowUnhidden',
  'windowUnminimized'
}

local deactivateEvents = {
  'windowDestroyed',
  'windowUnfocused',
  'windowNotOnScreen',
  'windowNotVisible',
  'windowHidden',
  'windowMinimized'
}

exclusionFilter:subscribe(activateEvents, on_exclusion_activated)
exclusionFilter:subscribe(deactivateEvents, on_exclusion_deactivated)
inclusionFilter:subscribe(activateEvents, on_inclusion_activated)

-- Enable by default
enable()

return obj
