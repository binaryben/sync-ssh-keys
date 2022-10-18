import
  std/os,
  std/strutils

var binName * = extractFilename(getAppFilename())

# Set $XDG_CONFIG_HOME path according to spec
proc getXDGBasePath (): string =
  var xdgConfigPath: string

  if(existsEnv("XDG_CONFIG_HOME")):
    xdgConfigPath = joinPath(getEnv("XDG_CONFIG_HOME"), binName)
  else:
    xdgConfigPath = joinPath(getHomeDir(), ".config", binName)

  return xdgConfigPath

proc getConfPath * (): string =
  var path: string

  const configEnvName = "SYNC_SSH_KEYS_CONFIG"

  const defaultConfigFileName = "sync.cfg"
  # * NOTE: altConfigFileName is only used when file is located in $HOME
  var altConfigFileName = @[".", extractFilename(getAppFilename())].join("")
  altConfigFileName = replace(altConfigFileName, "-", "_")

  # Use environment variables if set
  if(existsEnv(configEnvName)):
    path = getEnv(configEnvName)

  # Else use options set in $XDG_CONFIG_HOME or in home directory
  elif(fileExists(joinPath(getXDGBasePath(), defaultConfigFileName))):
    path = joinPath(getXDGBasePath(), defaultConfigFileName)
  elif(fileExists(joinPath(getHomeDir(), altConfigFileName))):
    path = joinPath(getHomeDir(), altConfigFileName)

  # Else fallback to defaults
  else:
    path = joinPath(getHomeDir(), ".ssh", defaultConfigFileName)

  return path