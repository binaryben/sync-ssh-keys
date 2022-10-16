import
  std/os,
  std/terminal,
  strutils

type ConfigType = enum
  cfg, keys

# Set $XDG_CONFIG_HOME path according to spec
proc getXDGBasePath (): string =
  var xdgConfigPath: string
  let binName = extractFilename(getAppFilename())

  if(existsEnv("XDG_CONFIG_HOME")):
    xdgConfigPath = joinPath(getEnv("XDG_CONFIG_HOME"), binName)
  else:
    xdgConfigPath = joinPath(getHomeDir(), ".config", binName)

  return xdgConfigPath

proc getConfPaths (to: ConfigType): string =
  var path: string

  const configEnvName = "SYNC_SSH_KEYS_CONFIG"
  const outputEnvName = "SYNC_SSH_KEYS_OUTPUT"

  const defaultConfigFileName = "sync.cfg"
  # * NOTE: altConfigFileName is only used when file is located in $HOME
  var altConfigFileName = @[".", extractFilename(getAppFilename())].join("")
  altConfigFileName = replace(altConfigFileName, "-", "_")

  # Use environment variables if set
  if(existsEnv(configEnvName) and to == cfg):
    path = getEnv(configEnvName)
  elif(existsEnv(outputEnvName) and to == keys):
    path = getEnv(outputEnvName)

  # Else use options set in $XDG_CONFIG_HOME or in home directory
  elif(fileExists(joinPath(getXDGBasePath(), defaultConfigFileName)) and to == cfg):
    path = joinPath(getXDGBasePath(), defaultConfigFileName)
  elif(fileExists(joinPath(getHomeDir(), altConfigFileName)) and to == cfg):
    path = joinPath(getHomeDir(), altConfigFileName)

  # Else fallback to defaults
  else:
    path = joinPath(getHomeDir(), ".ssh")
    if(to == cfg):
      path = joinPath(path, defaultConfigFileName)
    else:
      path = joinPath(path, "authorized_keys")

  return path

proc printHelp (config: string, output: string): void =
  stdout.styledWriteLine(styleBright, "CONFIG PATHS\n")
  echo("  Config file: ", config)
  echo("  Output file: ", output)
  stdout.styledWriteLine(styleBright, "\nUSAGE\n")
  stdout.styledWriteLine(styleDim, "  Print the config value to the terminal")
  echo("  ssh-keys config [section.option]\n")
  stdout.styledWriteLine(styleDim, "  Set the config value")
  echo("  ssh-keys config [section.option] [value]")
  echo("\nRun `ssh-keys config --help` for more information or view")
  echo("the online docs: https://github.com/binaryben/sync-ssh-keys.")

proc setOrGetConfig* (
  config: string = getConfPaths(cfg),
  output: string = getConfPaths(keys),
  savePaths: bool = true,
  args: seq[string],
): int =
  case args.len:
    of 2:
      echo("Lets get ", args[1])
      return 1
    of 3:
      echo("Lets set ", args[1])
      return 1
    else:
      printHelp(config, output)
      if(args.len > 3):
        return 1
      else:
        return 0
