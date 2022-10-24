import
  std/tables

import
  ../models/conf,
  ../utils/paths

const
  ConfigDoc * = "Modify settings for the system, users or groups"
  ConfigHelp * = {
    "file": "Path to config file (Optional)",
    "user": "ID of the user to get or modify (Optional)",
    "group": "ID of the group to get or modify (Optional)",
    "help": "CLIGEN-NOHELP",
    "version": "CLIGEN-NOHELP",
  }.toTable()
  ConfigUsage * = "ssh-keys $command <section.key> <value>\n\nOPTIONS\n$options"

proc configCommand * (
  file: string = getConfPath(),
  user: string = "",
  group: string = "",
  unset: bool = false,
  reset: bool = false,
  args: seq[string],
): int =
  case args.len:
    of 2:
      echo getConf(args[1])
      return 0
    of 3:
      echo setConf(file, args[1], args[2])
      return 0
    else:

      if(args.len > 3):
        return 1
      else:
        return 0
