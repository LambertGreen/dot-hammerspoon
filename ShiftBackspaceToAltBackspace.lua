-- Maps Shift-Backspace to Alt-Backspace (backward-kill-word)
-- This allows backward word deletion using a more convenient key combination

local log = hs.logger.new('ShiftBackspaceToAltBackspace')

local function on_keydown(evt)
    local keycode = evt:getKeyCode()
    local flags = evt:getFlags()

    -- Check if this is Shift-Backspace
    -- Backspace keycode is 51
    if keycode == 51 and flags.shift and not flags.cmd and not flags.ctrl and not flags.alt then
        log.d('Shift-Backspace pressed: sending Alt-Backspace')

        -- Send Alt-Backspace instead
        hs.eventtap.event.newKeyEvent({'alt'}, 'delete', true):post()
        hs.eventtap.event.newKeyEvent({'alt'}, 'delete', false):post()

        -- Return true to suppress the original Shift-Backspace event
        return true
    end

    -- Return false to allow other key events to pass through
    return false
end

-- Create the event tap
local key_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, on_keydown)

-- Start the event tap
key_tap:start()

log.i("ShiftBackspaceToAltBackspace: enabled")

return {}
