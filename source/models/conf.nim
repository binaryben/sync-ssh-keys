import
  std/os,
  std/parsecfg,
  std/strutils,
  std/tables

import
  api,
  ../utils/paths

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

const log = {
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
  "log": log,         # Logging config
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
    writeFile(config, "")
    var cfg = loadConfig(config)

    # We only need the version to persist in case of breaking changes
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
  key: string,
): string =

  let config = getConfPath()
  let splitKey = splitConfKey(key)
  var cfg = loadConfig(config)
  return cfg.getSectionValue(splitKey.section, splitKey.subsection)

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
