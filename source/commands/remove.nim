import
  std/tables

import
  ../utils/paths

const
  RemoveDoc * = "Remove a saved user or group"
  RemoveHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  RemoveUsage * = binName & " $command"

proc removeCommand* (
  args: seq[string],
): int =
  echo "This is the remove command"
  return 1
