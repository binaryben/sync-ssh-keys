import
  std/parsecfg,
  std/terminal,
  std/os,
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

proc done(message: string): void =
  stdout.styledWriteLine(fgGreen, "✔", fgDefault, styleDim, "  ", message)

proc warn(message: string): void =
  stdout.styledWriteLine(fgYellow, styleBright, "⚠️  ", message)

proc ensureSSHFilesExist(file: string): void =
  if(not fileExists(file)):
    warn("Configured SSH key file does not exist. Creating it now.")
    writeFile(file, "")
    done(file)
  else:
    done("SSH files are ready for configuration")

  # echo(getFilePermissions(keyFile))
  # echo "mkdir -p ~/.ssh"
  # echo "chmod 700 ~/.ssh"
  # echo "touch ~/.ssh/authorized_keys"

proc ensureSSHPermissions(): void =
  # echo "chmod 700 ~/.ssh"
  # echo "chmod 600 ~/.ssh/authorized_keys"
  # echo "echo \"ssh-rsa KEYGOESHERE user@remotehost or note\" >> ~/.ssh/authorized_keys"
  done("SSH config files already have correct permissions")

proc writeSSHKeys (file: string, lines: seq[string]) =
  let f = open(file, fmWrite)
  defer: f.close()

  for line in lines:
    f.writeLine(line)

  done("Keys successfully saved")

proc syncAuthorizedUsers* (
  args: seq[string],
  config: string = getConfPath(),
): int =
  ensureConfigExists(config)
  echo("Confirming SSH files exist...\n")
  ensureSSHFilesExist(getConf(config, "path.keys"))
  notify(SYNC_START, config)

  const DELIMITER_START = "-----BEGIN SYNCED SSH USER KEYS-----"
  const DELIMITER_END = "-----END SYNCED SSH USER KEYS-----"

  var authorizedUsers = getConf(config, "path.users")
  var output: seq[string] = @[]

  echo "\nDownloading SSH Keys...\n"

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
      done(@["Downloaded", count, "keys for", user].join(" "))
    else:
      warn(@["Could not load any keys for", user].join(" "))

  echo "\nSaving SSH Keys...\n"
  writeSSHKeys(getConf(config, "path.keys"), output)
  ensureSSHPermissions()
  notify(SYNC_SUCCESS, config)

  return 0