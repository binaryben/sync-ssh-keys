import
  std/tables

import
  ../utils/paths

const
  InstallDoc * = "Install '" & binName & " sync' as a cron service"
  InstallHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  InstallUsage * = binName & " $command"

proc installCommand* (
  args: seq[string],
): int =
  echo "This is the install command"
  return 1
