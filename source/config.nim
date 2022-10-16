import
  std/os,
  std/terminal,
  std/parsecfg,
  strutils

import utils

type ConfigType = enum
  cfg, keys

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

proc printHelp (config: string): void =
  stdout.styledWriteLine(styleBright, "CONFIG PATHS\n")
  echo("  Config file: ", config)
  stdout.styledWriteLine(styleBright, "\nUSAGE\n")
  stdout.styledWriteLine(styleDim, "  Print the config value to the terminal")
  echo("  ssh-keys config [section.option]\n")
  stdout.styledWriteLine(styleDim, "  Set the config value")
  echo("  ssh-keys config [section.option] [value]")
  echo("\nRun `ssh-keys config --help` for more information or view")
  echo("the online docs: https://github.com/binaryben/sync-ssh-keys.")

proc ensureConfigExists * (config: string): void =
  if(not fileExists(config)):
    writeFile(config, "")
    var cfg = loadConfig(config)

    # Default settings
    cfg.setSectionKey("", "version", "0")
    cfg.setSectionKey("", "force", "true")
    cfg.setSectionKey("", "cron", "0 * * * *")
    cfg.setSectionKey("", "telemetry", "true")

    # Default paths
    cfg.setSectionKey("path", "keys", joinPath(getHomeDir(), ".ssh", "authorized_keys"))
    cfg.setSectionKey("path", "users", joinPath(getHomeDir(), ".ssh", "authorized_users"))
    cfg.setSectionKey("path", "groups", joinPath(getHomeDir(), ".ssh", "authorized_groups"))
    cfg.setSectionKey("path", "recovery", joinPath(getHomeDir(), ".ssh", "recovery_keys"))

    # Logging config
    cfg.setSectionKey("log", "level", "info")
    cfg.setSectionKey("log", "directory", "info")

    # Healthchecks
    cfg.setSectionKey("health", "ping", "false")
    cfg.setSectionKey("health", "start", "https://hc-ping.com/{{uuid}}/start")
    cfg.setSectionKey("health", "success", "https://hc-ping.com/{{uuid}}")
    cfg.setSectionKey("health", "fail", "https://hc-ping.com/{{uuid}}/fail")

    # Default Git Platform API routes
    cfg.setSectionKey("github", "url", "https://api.github.com")
    cfg.setSectionKey("github", "endpoint", "users/{{user}}/keys")
    cfg.setSectionKey("gitlab", "url", "https://api.github.com/")
    cfg.setSectionKey("gitlab", "endpoint", "/users/{{user}}/keys")
    cfg.setSectionKey("bitbucket", "url", "https://api.bitbucket.org/2.0")
    cfg.setSectionKey("bitbucket", "endpoint", "/users/{{user}/ssh-keys")
    cfg.setSectionKey("gitea", "url", "https://api.github.com")
    cfg.setSectionKey("gitea", "resource", "/users/{{user}}/keys")
    cfg.setSectionKey("git", "url", "https://example.com")
    cfg.setSectionKey("git", "resource", "/users/{{user}}/keys")

    # S3 placeholders
    cfg.setSectionKey("s3", "endpoint", "false")
    cfg.setSectionKey("s3", "key", "false")
    cfg.setSectionKey("s3", "secret", "false")
    cfg.setSectionKey("s3", "region", "false")
    cfg.setSectionKey("s3", "bucket", "false")
    cfg.setSectionKey("s3", "directory", "false")

    # IAM placeholders (defaults to AWS)
    cfg.setSectionKey("iam", "endpoint", "false")

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
      printHelp(config)
      if(args.len > 3):
        return 1
      else:
        return 0
