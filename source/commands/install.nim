import
  std/tables

import
  ../utils/paths

const
  InstallDoc * = "Modify settings for the system, users or groups"
  InstallHelp * = {
    "help": "CLIGEN-NOHELP",
    "version": "CLIGEN-NOHELP",
  }.toTable()
  InstallUsage * = binName & " $command"

proc installCommand* (
  args: seq[string],
): int =
  echo "This is the install command"
  return 1
