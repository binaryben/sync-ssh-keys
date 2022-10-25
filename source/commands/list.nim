import # Libraries
  std/tables

import # Local
  ../utils/[logger, paths]

const
  ListDoc * = "List saved config, users and groups"
  ListHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  ListUsage * = binName & " $command"

let log = newLogger("cli:list")
log.debug("command ready for cli dispatch")

proc listCommand* (
  args: seq[string],
): int =
  echo "This is the list command"
  return 1
