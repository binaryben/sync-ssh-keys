import # Libraries
  std/tables

import # Local
  ../models/[users, groups/generic, groups/types],
  ../utils/[consts, logger]

const
  ListDoc * = "List saved config, users and groups"
  ListHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  ListUsage * = binName & " $command"

let log = newLogger("cli:list")
log.debug("command ready for cli dispatch")

proc listCommand* (
  user: string = "",
  group: string = "",
  args: seq[string],
): int =

  if user != "":
    let payload = getUser(user)

    if payload.status == UserStatus.Exists:
      echo "{"
      echo "  \"user\": \"" & payload.user & "\""
      echo "  \"name\": \"" & payload.name & "\""
      echo "  \"provider\": \"" & payload.provider & "\""
      echo "  \"api\": \"" & payload.api & "\""
      echo "  \"token\": \"" & payload.token & "\""
      echo "  \"meta\": \"" & payload.meta & "\""
      echo "  \"keys\": \"" & payload.keys & "\""
      echo "}"
      return 0
    elif payload.status == UserStatus.Ghost:
      log.warn("User '" & user & "' not found")
      log.console("Check the spelling and try again.")
      log.console("User may be part of an authorized group instead of saved individually.")
      return 1

  elif group != "":
    let payload = getGroup(group)

    if payload.status == GroupStatus.Exists:
      echo "{"
      echo "  \"group\": \"" & payload.group & "\""
      echo "  \"name\": \"" & payload.name & "\""
      echo "  \"token\": \"" & payload.token & "\""
      echo "}"
      return 0
    elif payload.status == GroupStatus.Ghost:
      log.warn("Group '" & group & "' not found")
      log.console("Check the spelling and try again.")
      return 1
