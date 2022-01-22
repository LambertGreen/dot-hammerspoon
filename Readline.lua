local modal = hs.hotkey.modal.new()

hs.window.filter.new{'Alfred', 'Contexts'}
    :subscribe(hs.window.filter.windowFocused,function()
        modal:enter()
    end)
    :subscribe(hs.window.filter.windowUnfocused,function()
        modal:exit()
    end)

-- Running into the following issues with the below:
-- 1. The <ctrl-k> does not work in Contexts
-- 2. Even with the small timeout it is perceptively slow
-- 3. Hammerspoon got into a state where <ctrl-u> was not
--    working right for apps not in the filter list i.e
--    it broke iTerm!
modal:bind({'ctrl'}, 'u', function()
    hs.eventtap.keyStroke({'ctrl'}, 'a')
    hs.timer.usleep(50)
    hs.eventtap.keyStroke({'ctrl'}, 'k')
end)

return modal
