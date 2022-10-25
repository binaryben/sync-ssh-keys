import # Libraries
  std/tables

import # Local
  ../utils/[logger, paths]

const
  InstallDoc * = "Install '" & binName & " sync' as a cron service"
  InstallHelp * = {
    "help": "CLIGEN-NOHELP",
  }.toTable()
  InstallUsage * = binName & " $command"

let log = newLogger("cli:install")
log.debug("command ready for cli dispatch")

proc installCommand* (
  args: seq[string],
): int =
  echo "This is the install command"
  return 1
