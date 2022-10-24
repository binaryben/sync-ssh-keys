import
  std/os,
  std/tables,
  std/parsecfg,
  strutils

import ../utils/consts

const
  ConfigDoc * = "Get and set global config settings"
  ConfigHelp * = {
    "config": "Path to config file (Optional)",
    "help": "CLIGEN-NOHELP",
    "version": "CLIGEN-NOHELP",
  }.toTable()
  # ConfigShort = { "key": 'z' }.toTable()
  ConfigUsage * = "ssh-keys $command <section.key> <value>\n\nOPTIONS\n$options"

proc ensureConfigExists * (config: string): void =
  if(not fileExists(config)):
    writeFile(config, "")
    var cfg = loadConfig(config)

    # Default settings
    cfg.setSectionKey("", "version", "0")

    # Write defaults
    cfg.writeConfig(config)

type
  ConfKey = object
    section: string
    subsection: string

proc splitConfKey (key: string): ConfKey =
  let splitKey = split(key, ".", 1)

  return ConfKey(
    section: if splitKey.len == 1: "" else: splitKey[0],
    subsection: if splitKey.len == 1: splitKey[0] else: splitKey[1],
  )

proc getConf * (
  config: string = getConfPath(),
  key: string,
): string =
  ensureConfigExists(config)
  let splitKey = splitConfKey(key)
  var cfg = loadConfig(config)
  return cfg.getSectionValue(splitKey.section, splitKey.subsection)

proc setConf * (
  config: string = getConfPath(),
  key: string,
  value: string,
): string =
  ensureConfigExists(config)
  let splitKey = splitConfKey(key)
  var cfg = loadConfig(config)
  cfg.setSectionKey(splitKey.section, splitKey.subsection, value)
  cfg.writeConfig(config)
  return cfg.getSectionValue(splitKey.section, splitKey.subsection)

proc setOrGetConfig * (
  config: string = getConfPath(),
  args: seq[string],
): int =
  case args.len:
    of 2:
      echo getConf(config, args[1])
      return 0
    of 3:
      echo setConf(config, args[1], args[2])
      return 0
    else:
      ensureConfigExists(config)
      if(args.len > 3):
        return 1
      else:
        return 0
