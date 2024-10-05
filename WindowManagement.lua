-- Provides window management functions
--
-- Currently window movement is being delegated to Divvy because:
-- 1. I am already paid for Divvy and am using it both on macOS and Windows
-- 2. Divvy provides nice mouse controls (e.g. menubar access)
-- 3. Divvy provides margins/gaps
--
-- It is possible to replace Divvy with Hammerspoon scripting, but I don't
-- plan on doing this until there is a clear need to do so.
--

-- A nicer hide other windows function that is specific to the current screen
hs.hotkey.bind({"cmd", "alt"}, "H", function()
    local currentScreen = hs.screen.mainScreen()
    local currentSpace = hs.spaces.focusedSpace()
    local allWindows = hs.window.orderedWindows()
    local mainWindow = hs.window.frontmostWindow()

    -- Get frame of the frontmost window
    local mainFrame = mainWindow:frame()

    -- Limit to windows on the current screen and in the same space
    for _, win in ipairs(allWindows) do
        if win:screen() == currentScreen and hs.spaces.windowSpaces(win)[1] == currentSpace then
            if win ~= mainWindow then
                local otherFrame = win:frame()

                -- Check if the window is partially or fully underneath the frontmost window
                if mainFrame:intersect(otherFrame) then
                    win:application():hide()
                end
            end
        end
    end
end)

-- TODO The below is very dicey code that just blind invokes hotkeys (relying on Divvy to setup correctly)

local obj = {}
local moveWindowPrefix = {'ctrl', 'cmd', 'alt'}
-- Window movement
obj.moveWindowLeft = function() hs.eventtap.keyStroke(moveWindowPrefix, 'h') end
obj.moveWindowDown = function() hs.eventtap.keyStroke(moveWindowPrefix, 'j') end
obj.moveWindowUp = function() hs.eventtap.keyStroke(moveWindowPrefix, 'k') end
obj.moveWindowRight = function() hs.eventtap.keyStroke(moveWindowPrefix, 'l') end
obj.moveWindowTopLeft = function() hs.eventtap.keyStroke(moveWindowPrefix, 'u') end
obj.moveWindowTopRight = function() hs.eventtap.keyStroke(moveWindowPrefix, 'i') end
obj.moveWindowBottomLeft = function() hs.eventtap.keyStroke(moveWindowPrefix, 'n') end
obj.moveWindowBottomRight = function() hs.eventtap.keyStroke(moveWindowPrefix, 'm') end
obj.moveWindowMaximize = function() hs.eventtap.keyStroke(moveWindowPrefix, 'f') end
obj.moveWindowCenter = function() hs.eventtap.keyStroke(moveWindowPrefix, 'd') end
return obj

