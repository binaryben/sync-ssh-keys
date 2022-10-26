# Inspiration: https://github.com/unitpas/syncssh

import # Libraries
  std/tables

import # Local
  ../utils/[consts, logger]

const
  PushDoc * = "Push local SSH key to a provider"
  PushHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  PushUsage * = binName & " $command"

let log = newLogger("cli:push")
log.debug("command ready for cli dispatch")

proc pushCommand* (
  args: seq[string],
): int =
  echo "This is the push command"
  return 1
