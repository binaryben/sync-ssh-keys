import
  std/tables

import
  ../utils/paths

const
  ListDoc * = "List saved config, users and groups"
  ListHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  ListUsage * = binName & " $command"

proc listCommand* (
  args: seq[string],
): int =
  echo "This is the list command"
  return 1
