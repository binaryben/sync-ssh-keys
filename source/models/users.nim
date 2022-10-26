import std/parsecfg

import
  ../models/conf

# May be expanded later to source path from cli values
proc getAuthorizedUserPath (): string =
  result = getConf("path.users")

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
    url*: string
    endpoint*: string

proc getUser * (
  user: string
): User =
  let file = getAuthorizedUserPath()
  let authorizedUsers = loadConfig(file)

  return User(
    status: UserStatus.Exists,
    user: user,
    name: authorizedUsers.getSectionValue(user, "name"),
    provider: authorizedUsers.getSectionValue(user, "provider"),
    url: authorizedUsers.getSectionValue(user, "url"),
    endpoint: authorizedUsers.getSectionValue(user, "endpoint"),
  )

proc saveUser * (
  user: User
): bool =
  let file = getAuthorizedUserPath()
  var authorizedUsers = loadConfig(file)
  return false

proc removeUser * (
  user: string,
): bool =
  let file = getAuthorizedUserPath()
  var authorizedUsers = loadConfig(file)
  authorizedUsers.delSection(user)
  authorizedUsers.writeConfig(file)
  return true


# proc setConf * (
#   user: string,
#   value: string,
# ): string =

#   let splitKey = splitConfKey(key)
#   var cfg = loadConfig(config)
#   cfg.setSectionKey(splitKey.section, splitKey.subsection, value)
#   cfg.writeConfig(config)
#   return cfg.getSectionValue(splitKey.section, splitKey.subsection)
