-- SafeQuit.lua - Prevent accidental CMD+Q quits
-- Press CMD+Q twice within 1.5 seconds to quit an application

local SafeQuit = {}

local lastCmdQ = 0

function SafeQuit.init()
  hs.hotkey.bind({'cmd'}, 'q', function()
    local app = hs.application.frontmostApplication()
    if not app then return end

    local interval = hs.timer.secondsSinceEpoch() - lastCmdQ
    lastCmdQ = hs.timer.secondsSinceEpoch()

    if interval < 1.5 then
      -- Second press within 1.5 seconds - quit the app
      app:selectMenuItem("Quit.*")
    else
      -- First press - show warning
      hs.alert.show("Press ⌘Q again to quit " .. app:name(), 1)
    end
  end)
end

function SafeQuit.disable()
  hs.hotkey.disableAll({'cmd'}, 'q')
end

function SafeQuit.enable()
  SafeQuit.init()
end

-- Auto-initialize when required
SafeQuit.init()

return SafeQuit
