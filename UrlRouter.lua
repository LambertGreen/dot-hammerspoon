-- Route the opening of URLs to a specific Google Chrome profile
--
-- Profile information is obtained from navigating to 'chrome://version'

ChromeApp = "/Applications/Google Chrome Beta.app"
ChromeAppExe = ChromeApp.."/Contents/MacOS/Google Chrome Beta"
ChromeDataDir = "~/Library/Application Support/Google/Chrome Beta/"
ChromeBrowserAppId = hs.application.infoForBundlePath(ChromeApp)['CFBundleIdentifier']

-- local log = require("hs.logger").new("UrlRouter")

function OpenChromeWithProfile(profile, url)
  local t = hs.task.new(
    ChromeAppExe,
    function(exitCode, stdOut, stdErr)
      -- log.df("exitCode: %s", exitCode)
      -- log.df("stdOut: %s", stdOut)
      -- log.df("stdErr: %s", stdErr)
    end,
    function(task, stdOut, stdErr)
      -- log.df("task: %s", task)
      -- log.df("stdOut: %s", stdOut)
      -- log.df("stdErr: %s", stdErr)
      return true
    end,
    {profile, url})
  t:start()
end

-- TODO This routing is not working with the issue being the profile part
-- I think it would work just fine if we are using two different browsers.
-- Things may appear to be working, but what is actually happening is the Chrome will
-- reuse the profile that was last used.
--
chromePersonalProfile = hs.fnutils.partial(OpenChromeWithProfile, "--user-profile="..ChromeDataDir.."Default")
chromeWorkProfile = hs.fnutils.partial(OpenChromeWithProfile, "--user-profile="..ChromeDataDir.."Profile 2")

spoon.SpoonInstall:andUse(
  "URLDispatcher", {
    config = {
      url_patterns = {
        { "https?://.*tableau%.com", nil, chromeWorkProfile },
        { "https?://.*tsi%.lan", nil, chromeWorkProfile },
        { "https?://.*salesforce%.com", nil, chromeWorkProfile },
        { "https?://.*reddit%.com", nil, chromePersonalProfile },
        { "https?://.*github%.com", nil, chromePersonalProfile },
      },
      default_handler = ChromeBrowserAppId,
    },
    start = true,
})

-- spoon.URLDispatcher.logger.defaultLogLevel = "debug"
