-- Move windows by holding Cmd and dragging
local dragging = false
local dragStart = nil
local windowStart = nil
local dragWindow = nil  -- Store the window reference during drag

local function startDrag()
    local win = hs.window.focusedWindow()
    if win then
        dragging = true
        dragWindow = win  -- Store window reference
        dragStart = hs.mouse.absolutePosition()
        windowStart = win:frame()
    end
end

local function doDrag()
    if dragging and dragWindow and dragStart and windowStart then
        local mousePos = hs.mouse.absolutePosition()
        local newFrame = hs.geometry.copy(windowStart)
        newFrame.x = windowStart.x + (mousePos.x - dragStart.x)
        newFrame.y = windowStart.y + (mousePos.y - dragStart.y)
        dragWindow:setFrame(newFrame, 0)
    end
end

local function endDrag()
    dragging = false
    dragWindow = nil
    dragStart = nil
    windowStart = nil
end

-- Store event taps in variables to prevent garbage collection
local mouseDownTap = hs.eventtap.new({hs.eventtap.event.types.leftMouseDown}, function(e)
    if hs.eventtap.checkKeyboardModifiers()['cmd'] then
        startDrag()
    end
end)

local mouseDraggedTap = hs.eventtap.new({hs.eventtap.event.types.leftMouseDragged}, doDrag)

local mouseUpTap = hs.eventtap.new({hs.eventtap.event.types.leftMouseUp}, function(e)
    endDrag()
end)

-- Start the event taps
mouseDownTap:start()
mouseDraggedTap:start()
mouseUpTap:start()

