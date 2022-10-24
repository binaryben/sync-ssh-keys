import
  std/os,
  std/tables

import api

# Default configuration values

const system = {
  "force": "true",
  "provider": "github",
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

# let section = "path"

# echo default[section]["keys"]
