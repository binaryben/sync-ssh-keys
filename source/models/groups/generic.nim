import # Libraries
  std/parsecfg

import # Local
  types,
  ../../models/conf,
  ../../utils/logger

let log = newLogger("models:groups")

# May be expanded later to source path from cli values
proc getAuthorizedGroupsPath * (): string =
  result = getConf("path.groups")
  log.debug("authorized_groups file: " & result)

proc groupExists * (group: string): bool =
  log.debug("checking if " & group & " exists")
  let file = getAuthorizedGroupsPath()
  let authorizedGroups = loadConfig(file)

  for authorizedGroup in authorizedGroups.sections:
    if authorizedGroup == group:
      log.debug(group & " found in " & file)
      return true

  log.debug(group & " NOT found in " & file)
  return false

proc getGroup * (
  group: string,
  recursive: bool = true,
): Group or GitGroup =
  let file = getAuthorizedGroupsPath()
  let authorizedGroups = loadConfig(file)

  result = Group(
    status: if groupExists(group): GroupStatus.Exists else: GroupStatus.Ghost,
    group: group,
    name: authorizedGroups.getSectionValue(group, "name"),
    token: authorizedGroups.getSectionValue(group, "token"),
  )

proc removeGroup * () =
  echo "Remove generic group"

proc saveGroup * () =
  echo "Save generic group"
