-- Application watcher

-- Setup a logger
local log = hs.logger.new('AppWatcher')

function applicationWatcherCallback(appName, eventType, appObject)
    log.df("ApplicationWatcher: %s, %s, %s", appName, evenType, appObject)
    if (eventType == hs.application.watcher.activated) then
        log.df("ApplicationWatcher: Activated: %s, %s, %s", appName, evenType, appObject)
        if (appName == "Emacs") then
            -- Bring Emacs to Front
            hs.osascript.applescript('tell application "Emacs" to activate')
        end
    end
end


-- We do not need the AppWatcher running all the time so commenting it out for now.
-- watcher = hs.application.watcher.new(applicationWatcherCallback)
-- watcher:start()
