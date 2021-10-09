-- Application watcher

-- Setup a logger
local log = hs.logger.new('AppWatcher')

function applicationWatcherCallback(appName, eventType, appObject)
    log.i(appName)
end


-- We do not need the AppWatcher running all the time so commenting it out for now.
-- watcher = hs.application.watcher.new(applicationWatcherCallback)
-- watcher:start()
