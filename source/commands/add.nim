from std/tables import toTable

import
  std/os,
  std/terminal,
  std/parsecfg,
  strutils

import
  ../models/conf,
  ../utils/logger,
  ../utils/paths

const
  AddDoc * = "Add a user or group to be synced"
  AddHelp * = {
    "help": "CLIGEN-NOHELP",
    "version": "CLIGEN-NOHELP",
  }.toTable()
  # AddShort = { "key": 'z' }.toTable()
  AddUsage * = "ssh-keys $command [options]\n\n\e[1mOPTIONS\e[m\n$options"

var log = newLogger("cli:add")

proc getSecretFromUser (prompt: string, reason: string) : string =
  echo(reason)
  var secret = readPasswordFromStdin(@[prompt, ": "].join(""))
  if (secret == ""):
    echo("You have not entered anything.")
    echo("This will save but will not work until you enter a valid key")
    echo("You can manually enter this in: ")
    secret = "false"
  return secret

proc addAuthorizedUser* (
  config: string = getConfPath(),
  user: string = "",
  name: string = "",
  provider: string = "inherit",
  url: string = "",
  endpoint: string = "",
  interactive: bool = false,
  args: seq[string],
): int =
  log.debug("Starting execution of add command")

  let usersFile = getConf("path.users")
  if(not fileExists(usersFile)):
    writeFile(usersFile, "")

  if(user != ""):
    var users = loadConfig(usersFile)
    users.setSectionKey(user, "provider", provider)
    if(name != ""):
      users.setSectionKey(user, "name", name)
    if(url != ""):
      users.setSectionKey(user, "url", url)
    if(endpoint != ""):
      users.setSectionKey(user, "endpoint", endpoint)

    users.writeConfig(usersFile)

  return 1

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