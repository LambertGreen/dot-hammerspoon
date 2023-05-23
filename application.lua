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

-- Override 'CMD+q' to not silently kill application
local applicationHotkey = hs.hotkey.new({ "cmd" }, "Q", function()
    obj.appKill9()
end)

-- Enable the hotkey
applicationHotkey:enable()

return obj
