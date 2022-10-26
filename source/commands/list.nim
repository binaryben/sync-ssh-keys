import # Libraries
  std/tables

import # Local
  ../models/users,
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
  user: string,
  args: seq[string],
): int =
  let payload = getUser(user)
  echo "{"
  echo "  \"user\": \"" & payload.user & "\""
  echo "  \"name\": \"" & payload.name & "\""
  echo "  \"provider\": \"" & payload.provider & "\""
  echo "  \"url\": \"" & payload.url & "\""
  echo "  \"endpoint\": \"" & payload.endpoint & "\""
  echo "}"
  return 1
