import # Libraries
  std/tables

import # Local
  ../models/users,
  ../utils/[consts, logger]

const
  RemoveDoc * = "Remove a saved user or group"
  RemoveHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  RemoveUsage * = binName & " $command"

let log = newLogger("cli:remove")
log.debug("command ready for cli dispatch")

proc removeCommand * (
  user: string,
  args: seq[string],
): int =
  log.debug("begin execution of command")
  if removeUser(user):
    log.success(user & " removed successfully")
    return 0
  else:
    echo "Something went wrong"
    return 1
