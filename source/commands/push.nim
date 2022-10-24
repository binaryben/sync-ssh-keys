# Inspiration: https://github.com/unitpas/syncssh

import
  std/tables

import
  ../utils/paths

const
  PushDoc * = "Push local SSH key to a provider"
  PushHelp * = {
    "help": "CLIGEN-NOHELP",
    "version": "CLIGEN-NOHELP",
  }.toTable()
  PushUsage * = binName & " $command"

proc pushCommand* (
  args: seq[string],
): int =
  echo "This is the push command"
  return 1
