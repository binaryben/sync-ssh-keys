import # Libraries
  cligen,
  std/[os, parsecfg, strutils, tables, terminal]

import # Local
  ../models/conf,
  ../utils/[consts, logger, paths]

const
  AddDoc * = "Add a user or group to be synced"
  AddHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  # AddShort = { "key": 'z' }.toTable()
  AddUsage * = "ssh-keys $command [options]\n\n\e[1mOPTIONS\e[m\n$options"

let log = newLogger("cli:add")
log.debug("command ready for cli dispatch")

proc getSecretFromUser (prompt: string, reason: string) : string =
  echo(reason)
  var secret = readPasswordFromStdin(@[prompt, ": "].join(""))
  if (secret == ""):
    echo("You have not entered anything.")
    echo("This will save but will not work until you enter a valid key")
    echo("You can manually enter this in: ")
    secret = "false"
  return secret

proc addAuthorizedUser * (
  config: string = getConfPath(),
  user: string = "",
  name: string = "",
  provider: string = "inherit",
  url: string = "",
  endpoint: string = "",
  interactive: bool = false,
  args: seq[string],
): int =
  log.debug("begin execution of command")

  if user == "":
    log.warn("Please provide a username to add")
    raise newException(HelpError, "Run '" & binName & " help add' for more information")

  let usersFile = getConf("path.users")
  if(not fileExists(usersFile)):
    writeFile(usersFile, "")

  var users = loadConfig(usersFile)
  users.setSectionKey(user, "provider", provider)
  if(name != ""):
    users.setSectionKey(user, "name", name)
  if(url != ""):
    users.setSectionKey(user, "url", url)
  if(endpoint != ""):
    users.setSectionKey(user, "endpoint", endpoint)

  users.writeConfig(usersFile)

proc addAuthorizedGroup* (
  config: string = getConfPath(),
  name: string = "",
  org: string = "",
  teams: string = "",
  provider: string = "inherit",
  url: string = "",
  endpoint: string = "",
  interactive: bool = false,
  args: seq[string],
): int =

  let groupsFile = getConf("path.groups")
  if(not fileExists(groupsFile)):
    writeFile(groupsFile, "")

  elif(org != "" and teams != ""):
    var groups = loadConfig(groupsFile)
    let token = getSecretFromUser("API Token", "Needed to access the provider")
    groups.setSectionKey(org, "token", token)
    groups.setSectionKey(org, "teams", teams)
    groups.setSectionKey(org, "provider", provider)
    if(url != ""):
      groups.setSectionKey(org, "url", url)
    if(endpoint != ""):
      groups.setSectionKey(org, "endpoint", endpoint)

    groups.writeConfig(groupsFile)

  return 1