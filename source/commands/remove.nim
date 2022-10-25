import # Libraries
  std/tables

import # Local
  ../utils/[logger, paths]

const
  RemoveDoc * = "Remove a saved user or group"
  RemoveHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  RemoveUsage * = binName & " $command"

let log = newLogger("cli:remove")
log.debug("command ready for cli dispatch")

proc removeCommand* (
  args: seq[string],
): int =
  echo "This is the remove command"
  return 1
