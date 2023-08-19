-- Provides application control
--
-- Application quit
local obj = {}
app = nil

obj.appKill9 = function()
    app = hs.application.frontmostApplication()
    hs.focus()
    local result = hs.dialog.blockAlert("Force kill application", "Are you sure?", "OK", "Cancel", "warning")
    if result == "OK" then
        app:kill9()
    end
end

-- TODO: Decide if this should be filtered to whether Contexts is running or not.
-- Update 8/19/23: Disabling for now since closing apps via Contexts is pretty handy
-- and this config is currently intercepting it.
--
-- Override 'CMD+q' to not silently kill application
-- local applicationHotkey = hs.hotkey.new({ "cmd" }, "Q", function()
--     obj.appKill9()
-- end)

-- Enable the hotkey
-- applicationHotkey:enable()

return obj
