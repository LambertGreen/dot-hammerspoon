
local logger = hs.logger.new('HideCoveredWindows', 'info')

local function hideCoveredWindows()
    local currentScreen = hs.screen.mainScreen()
    local currentSpace = hs.spaces.focusedSpace()
    local allWindows = hs.window.orderedWindows()
    local mainWindow = hs.window.frontmostWindow()

    if not mainWindow then
        hs.alert.show("No active window")
        return
    end

    local mainFrame = mainWindow:frame()
    local mainApp = mainWindow:application()
    local mainAppName = mainApp and mainApp:name() or "Unknown"
    local hiddenCount = 0

    logger.i("Front window: " .. mainAppName .. " - " .. mainWindow:title())
    logger.i(string.format("Front window frame: x=%d y=%d w=%d h=%d",
        mainFrame.x, mainFrame.y, mainFrame.w, mainFrame.h))

    for _, win in ipairs(allWindows) do
        if win ~= mainWindow then
            local app = win:application()
            local appName = app and app:name() or "Unknown"
            local winTitle = win:title()

            if win:screen() == currentScreen and hs.spaces.windowSpaces(win)[1] == currentSpace then
                local frame = win:frame()
                local intersection = mainFrame:intersect(frame)

                logger.i(string.format("Checking %s (%s) - overlap area: %d",
                    appName, winTitle, intersection.w * intersection.h))

                if intersection.w > 0 and intersection.h > 0 then
                    logger.i("  -> Minimizing: " .. appName .. " (" .. winTitle .. ")")
                    win:minimize()
                    hiddenCount = hiddenCount + 1
                end
            end
        end
    end

    hs.alert.show("Minimized " .. hiddenCount .. " covered windows", 1)
    logger.i("Minimized " .. hiddenCount .. " windows")
end

return {
    hideCoveredWindows = hideCoveredWindows
}
