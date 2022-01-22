-- Makes the Control key double up as an Escape key.
-- Works well together with mapping the Capslock key to Control key.
--    Capslock can be mapped to Control using OS Preferences or Karabiner Elements.
--
-- From: https://gist.github.com/zcmarine/f65182fe26b029900792fa0b59f09d7f

local log = hs.logger.new('CtrlToEscape', 'debug')
local send_escape = false
local prev_modifiers = {}
local obj = {}
local is_enabled = false

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

-- Setup a excluded application filter
exclusion = hs.window.filter.new{
    'Remotix',
    'VirtualBox VM',
    'Screen Sharing',
    'UTM',
    "Windows 11",
    "Parallels Desktop",
    'NoMachine',
    -- 'NoMachine Monitor',
    -- 'QuickLookUIService',
    -- 'ndock',
    -- 'nxplayer',
    "Geforce Now"
}

exclusion:setAppFilter('NoMachine', {allowTitles=1})

-- On ctrl down check if we should convert to an escape
ctrl_to_escape_modifier_tap = hs.eventtap.new(
    {hs.eventtap.event.types.flagsChanged},
    function(evt)
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
)

-- If any non-modifier key is pressed, we know we won't be sending an escape
ctrl_to_escape_non_modifier_tap = hs.eventtap.new(
    {hs.eventtap.event.types.keyDown},
    function(evt)
        send_escape = false
        return false
    end
)

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

exclusion:subscribe(hs.window.filter.windowFocused, disable)
exclusion:subscribe(hs.window.filter.windowUnfocused, enable)

enable()

obj.toggle = function()
    if is_enabled then
        disable()
    else
        enable()
    end
end

return obj
