-- Below information on installed Chrome obtained from navigating to 'chrome://version'
--
-- Executable Path /Applications/Google Chrome Beta.app/Contents/MacOS/Google Chrome Beta
-- Profile Path /Users/lambert.green/Library/Application Support/Google/Chrome Beta/Profile 2

function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end

chromeBrowser = appID('/Applications/Google Chrome Beta.app')

-- open Chrome with a specific named Profile
function chromeWithProfile(profile, url)
  local t = hs.task.new(
    "/Applications/Google Chrome Beta.app/Contents/MacOS/Google Chrome Beta",
    nil,
    function() return false end,
    {"--profile-directory=/Users/lambert.green/Library/Application Support/Google/Chrome Beta/" .. profile, url})
  t:start()
end

chromeWorkProfile = hs.fnutils.partial(chromeWithProfile, "Profile 2")
chromePersonalProfile = hs.fnutils.partial(chromeWithProfile, "Default")

spoon.SpoonInstall:andUse(
  "URLDispatcher", {
    config = {
      url_patterns = {
        { "https?://.*tableau%.com", nil, chromeWorkProfile },
        { "https?://.*tsi%.lan", nil, chromeWorkProfile },
        { "https?://.*salesforce%.com", nil, chromeWorkProfile },
      },
      default_handler = chromeBrowser
    },
    start = true,
})
