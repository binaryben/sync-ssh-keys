import # Libraries
  std/parsecfg

import # Local
  ../models/conf,
  ../utils/logger

let log = newLogger("models:users")

# May be expanded later to source path from cli values
proc getAuthorizedUsersPath (): string =
  result = getConf("path.users")
  log.debug("authorized_users file: " & result)

type
  UserStatus * = enum
    Ghost
    Exists
    Updated
    Created
    Deleted

  User * = object
    status*: UserStatus
    user*: string
    name*: string
    provider*: string
    api*: string
    token*: string
    meta*: string
    keys*: string

proc userExists * (user: string): bool =
  log.debug("checking if " & user & " exists")
  let file = getAuthorizedUsersPath()
  let authorizedUsers = loadConfig(file)

  for authorizedUser in authorizedUsers.sections:
    if authorizedUser == user:
      log.debug(user & " found in " & file)
      return true

  log.debug(user & " NOT found in " & file)
  return false

proc getUser * (
  user: string,
  recursive: bool = true,
): User =
  let file = getAuthorizedUsersPath()
  let authorizedUsers = loadConfig(file)

  result = User(
    status: if userExists(user): UserStatus.Exists else: UserStatus.Ghost,
    user: user,
    name: authorizedUsers.getSectionValue(user, "name"),
    provider: authorizedUsers.getSectionValue(user, "provider"),
    api: authorizedUsers.getSectionValue(user, "api"),
    token: authorizedUsers.getSectionValue(user, "token"),
    meta: authorizedUsers.getSectionValue(user, "meta"),
    keys: authorizedUsers.getSectionValue(user, "keys"),
  )

  if recursive and result.status == UserStatus.Exists:
    result.api = if result.api == "":
      getConf(result.provider & ".url")
      else: result.api
    result.token = if result.token == "":
      getConf(result.provider & ".token")
      else: result.token
    result.token = if result.token == "false": "" else: result.token
    result.meta = if result.meta == "":
      getConf(result.provider & ".user")
      else: result.meta
    result.keys = if result.keys == "":
      getConf(result.provider & ".keys")
      else: result.keys

proc saveUser * (
  user: User
): bool =
  let file = getAuthorizedUsersPath()
  var authorizedUsers = loadConfig(file)
  return false

proc removeUser * (
  user: string,
): bool =
  let file = getAuthorizedUsersPath()
  var authorizedUsers = loadConfig(file)
  authorizedUsers.delSection(user)
  authorizedUsers.writeConfig(file)
  return true
