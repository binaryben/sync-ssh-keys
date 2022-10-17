import
  std/parsecfg,
  std/terminal,
  strutils

import
  config,
  providers/git

type EventType = enum
  SYNC_START,
  SYNC_SUCCESS,
  SYNC_FAILURE,

proc notify (
  event: EventType,
  config: string
): void =
  var url: string
  var message: string
  let enabled: string = getConf(config, "health.enabled")

  case event:
    of SYNC_START:
      url = getConf(config, "health.start")
      message = @["Sending start notification to ", url, "\n"].join()
    of SYNC_SUCCESS:
      url = getConf(config, "health.success")
      message = @["\n", "Sending success notification to ", url].join()
    of SYNC_FAILURE:
      url = getConf(config, "health.fail")
      message = @["\n", "Sending failure notification to ", url].join()

  if(enabled == "true"):
    echo(message)

proc syncAuthorizedUsers* (
  args: seq[string],
  config: string = getConfPath(),
): int =
  ensureConfigExists(config)
  notify(SYNC_START, config)

  var authorizedUsers = getConf(config, "path.users")
  var output: seq[string] = @[]

  for user in sections(loadConfig(authorizedUsers)):
    stdout.styledWrite(styleDim, "Downloading keys for ", user, "...")
    var provider = @[user, "provider"].join(".")
    provider = getConf(authorizedUsers, provider)
    let keys = downloadKeysFromGitUser(user, provider = provider)
    stdout.eraseLine()

    if(keys.len > 0):
      for i in countup(0, keys.len - 1):
        add(output, keys[i])
      let count = intToStr(keys.len)
      stdout.styledWriteLine(fgGreen, "✔", fgDefault, styleDim, "  Downloaded ", count, " keys for ", user)
    else:
      stdout.styledWriteLine(fgYellow, "⚠️  Could not load any keys for ", user)

  notify(SYNC_SUCCESS, config)

  return 0