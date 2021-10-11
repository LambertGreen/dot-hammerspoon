-- Route the opening of URLs to a specific browser
--
-- Profile information is obtained from navigating to 'chrome://version'
--
-- Update: 09/11/2021:
-- Things suddenly have slowed down to a crawl, and I know not why.
--
-- Update: 09/10/2021:
-- I never could get using just Chrome with different profiles working
-- and ended up using Chrome for work related URLs and Brave otherwise.
--

ChromeApp = "/Applications/Google Chrome Beta.app"
ChromeAppExe = ChromeApp.."/Contents/MacOS/Google Chrome Beta"
ChromeDataDir = "~/Library/Application Support/Google/Chrome Beta/"
ChromeBrowserAppId = hs.application.infoForBundlePath("/Applications/Google Chrome Beta.app")['CFBundleIdentifier']
BraveBrowserAppId = hs.application.infoForBundlePath("/Applications/Brave Browser.app")['CFBundleIdentifier']

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

chromeWorkProfile = hs.fnutils.partial(OpenChromeWithProfile, "--user-profile="..ChromeDataDir.."Profile 2")

spoon.SpoonInstall:andUse(
  "URLDispatcher", {
    config = {
      url_patterns = {
        { "https?://.*tableau.*%.com", nil, chromeWorkProfile },
        { "https?://.*tsi%.lan", nil, chromeWorkProfile },
        { "https?://.*salesforce%.com", nil, chromeWorkProfile },
      },
      default_handler = ChromeBrowserAppId,
    },
    start = true,
})

-- spoon.URLDispatcher.logger.defaultLogLevel = "debug"
