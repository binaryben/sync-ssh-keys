import # Libraries
  std/[os, parsecfg, strutils]

import # Local
  ../models/[conf],
  ../providers/git,
  ../utils/[logger, paths]

let log = newLogger("sync")

type
  EventType = enum
    SYNC_START,
    SYNC_SUCCESS,
    SYNC_FAILURE,

  # KeyProviders = enum
  #   github,
  #   bitbucket,
  #   gitea,
  #   gitlab,
  #   git,
  #   iam,
  #   s3,

proc notify (
  event: EventType,
  config: string
): void =
  var url: string
  var message: string
  let enabled: string = getConf("health.enabled")

  case event:
    of SYNC_START:
      url = getConf("health.start")
      message = @["Sending start notification to ", url, "\n"].join()
    of SYNC_SUCCESS:
      url = getConf("health.success")
      message = @["\n", "Sending success notification to ", url].join()
    of SYNC_FAILURE:
      url = getConf("health.fail")
      message = @["\n", "Sending failure notification to ", url].join()

  if(enabled == "true"):
    echo(message)

proc ensureSSHFilesExist(file: string): void =
  if(not fileExists(file)):
    log.warn("Configured SSH key file does not exist. Creating it now.")
    writeFile(file, "")
    log.success(file)
  else:
    log.success("SSH files are ready for configuration")

  # echo(getFilePermissions(keyFile))
  # echo "mkdir -p ~/.ssh"
  # echo "chmod 700 ~/.ssh"
  # echo "touch ~/.ssh/authorized_keys"

proc ensureSSHPermissions(): void =
  # echo "chmod 700 ~/.ssh"
  # echo "chmod 600 ~/.ssh/authorized_keys"
  # echo "echo \"ssh-rsa KEYGOESHERE user@remotehost or note\" >> ~/.ssh/authorized_keys"
  log.success("SSH config files already have correct permissions")

proc writeSSHKeys (file: string, lines: seq[string]) =
  let f = open(file, fmWrite)
  defer: f.close()

  const DELIMITER_START = "----BEGIN SYNCED SSH USER KEYS-----"
  const DELIMITER_END = "-----END SYNCED SSH USER KEYS-----"

  f.writeLine(@["#", DELIMITER_START].join(" "))

  for line in lines:
    f.writeLine(line)

  f.writeLine(@["#", DELIMITER_END].join(" "))

  log.success("Keys successfully saved")

proc syncAuthorizedUsers* (
  args: seq[string],
  config: string = getConfPath(),
): int =

  log.title("Confirming SSH files exist...")
  ensureSSHFilesExist(getConf("path.keys"))
  notify(SYNC_START, config)

  var authorizedUsers = getConf("path.users")
  var output: seq[string] = @[]
  var failed: seq[string] = @[]

  log.title("Downloading SSH Keys...")

  for user in sections(loadConfig(authorizedUsers)):
    log.task(@["Downloading keys for", user, "..."].join(" "))
    var provider = @[user, "provider"].join(".")
    # provider = getUser(user, "provider")
    let keys = downloadKeysFromGitUser(user, provider = provider)

    if(keys.len > 0):
      add(output, @["#", user].join(" "))
      for i in countup(0, keys.len - 1):
        add(output, keys[i])
      let count = intToStr(keys.len)
      log.success(@["Downloaded", count, "keys for", user].join(" "))
    else:
      log.failure(@["Could not load any keys for", user].join(" "))
      add(failed, user)

  if (failed.len > 1):
    let count = intToStr(failed.len)
    log.warn(@[count, "users may not be able to login"].join(" "))
  elif (failed.len == 1):
    log.warn(@[failed[0], "may not be able to login"].join(" "))

  log.title("Saving SSH Keys...")
  writeSSHKeys(getConf("path.keys"), output)
  ensureSSHPermissions()
  notify(SYNC_SUCCESS, config)

  return 0