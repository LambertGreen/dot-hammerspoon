-- Clicks the "Close" button on the topmost notification
--
tell application "System Events"
    tell process "NotificationCenter"
        click button "Close" of window 1
    end tell
end tell
