local modal = hs.hotkey.modal.new()

hs.window.filter.new{'Alfred', 'Contexts'}
    :subscribe(hs.window.filter.windowFocused,function()
        modal:enter()
    end)
    :subscribe(hs.window.filter.windowUnfocused,function()
        modal:exit()
    end)

modal:bind({'ctrl'}, 'u', function()
    hs.eventtap.keyStroke({'ctrl'}, 'a')
    hs.timer.usleep(200)
    hs.eventtap.keyStroke({'ctrl'}, 'k')
end)

