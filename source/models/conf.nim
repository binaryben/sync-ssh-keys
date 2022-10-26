import # Libraries
  std/[os, parsecfg, strutils, tables]

import # Local
  api,
  ../utils/[logger, paths]

let log = newLogger("models:conf")

# Default configuration values

const system = {
  "force": "true",
  "provider": "github", # Can be overridden on user and group level
  "cron": "0 * * * *",
  "telemetry": "true",
}.toTable()

const path = {
  "keys": joinPath(getHomeDir(), ".ssh", "authorized_keys"),
  "users": joinPath(getHomeDir(), ".ssh", "authorized_users"),
  "groups": joinPath(getHomeDir(), ".ssh", "authorized_groups"),
  "recorvery": joinPath(getHomeDir(), ".ssh", "recovery_keys"),
}.toTable()

const logConfig = {
  "level": "info",
  "directory": joinPath(getHomeDir()),
}.toTable()

const health = {
  "ping": "false",
  "uuid": "false",
  "start": "https://hc-ping.com/{{uuid}}/start",
  "success": "https://hc-ping.com/{{uuid}}",
  "fail": "https://hc-ping.com/{{uuid}}/fail",
}.toTable()

const default = {
  "system": system,   # General settings
  "path": path,       # Default paths
  "log": logConfig,   # Logging config
  "health": health,   # Healthchecks endpoints
  "github": github,
  "gitlab": gitlab,
  "bitbucket": bitbucket,
  "gitea": gitea,
  "git": git,
}.toTable()

proc ensureConfigExists * (): void =
  let config = getConfPath()
  if(not fileExists(config)):
    log.debug("no config file fount at: " & config)
    log.debug("creating new config file now")
    writeFile(config, "")
    var cfg = loadConfig(config)

    # We only need the version to persist in case of breaking changes
    log.debug("saving minimum config to file")
    cfg.setSectionKey("", "version", "0")
    cfg.writeConfig(config)
  else:
    log.debug("config file already exists at: " & config)

type
  ConfKey = object
    section: string
    subsection: string

  # ConfResult = object
  #   value: string
  #   default: bool

proc splitConfKey (key: string): ConfKey =
  let splitKey = split(key, ".", 1)

  return ConfKey(
    section: if splitKey.len == 1: "" else: splitKey[0],
    subsection: if splitKey.len == 1: splitKey[0] else: splitKey[1],
  )

proc getConf * (
  key: string,
): string =
  log.debug("attempting to load value for '" & key & "'")
  let config = getConfPath()
  let splitKey = splitConfKey(key)
  var cfg = loadConfig(config)
  var value = cfg.getSectionValue(splitKey.section, splitKey.subsection)

  if value == "":
    log.debug("'" & key & "' not found in local configuration")
    value = default[splitKey.section][splitKey.subsection]
    log.debug("using default value for '" & key & "': " & value)
  else:
    log.debug("'" & key & "': " & value & " from local configuration")

  if value == "":
    log.debug("⚠️  '" & key & "' does not exist - this may trigger a fatal error in some cases")

  return value

proc setConf * (
  config: string = getConfPath(),
  key: string,
  value: string,
): string =

  let splitKey = splitConfKey(key)
  var cfg = loadConfig(config)
  cfg.setSectionKey(splitKey.section, splitKey.subsection, value)
  cfg.writeConfig(config)
  return cfg.getSectionValue(splitKey.section, splitKey.subsection)
