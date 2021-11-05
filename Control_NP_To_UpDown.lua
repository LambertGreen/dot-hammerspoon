
local modal = hs.hotkey.modal.new()

hs.window.filter.new{'Remotix'}
    :subscribe(hs.window.filter.windowFocused,function()
        modal:enter()
    end)
    :subscribe(hs.window.filter.windowUnfocused,function()
        modal:exit()
    end)

modal:bind({'ctrl'}, 'p', function()
    hs.eventtap.keyStroke({}, 'up')
end)

modal:bind({'ctrl'}, 'n', function()
    hs.eventtap.keyStroke({}, 'down')
end)


return modal
