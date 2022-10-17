import
  std/httpclient,
  std/json,
  strutils

import ../config

proc downloadKeysFromGitUser * (
  user: string,
  config: string = getConfPath(),
  provider: string = "github",
  url: string = "",
  endpoint: string = "",
  token: string = "",
  structure: string = "",
): seq[string] =
  ensureConfigExists(config)

  var keys: seq[string] = @[]
  var client = newHttpClient()

  # Add known headers
  if(provider == "github"):
    client.headers = newHttpHeaders({ "Accept": "application/vnd.github+json" })
  if(provider == "bitbucket"):
    client.headers = newHttpHeaders({ "Accept": "application/json" })

  # * Get API configuration settings
  # ! This is slow (read file every user) and could be done
  # ! in the syncAuthorizedUsers() proc.

  var confURL = @[provider, "url"].join(".")
  confURL = if (url == ""): getConf(config, confURL) else: url

  var confEndpoint = @[provider, "endpoint"].join(".")
  confEndpoint = if (endpoint == ""): getConf(config, confEndpoint) else: endpoint

  var confToken = @[provider, "token"].join(".")
  # TODO: Try getting token from user config first
  confToken = if (token == ""): getConf(config, confToken) else: token

  if (confToken != ""):
    var header: string = ""
    if (provider == "github" xor provider == "bitbucket"):
      header = @["Bearer", confToken].join(" ")
    elif (provider == "gitea"):
      header = @["token", confToken].join(" ")

    if(header != ""):
      client.headers = newHttpHeaders({ "Authorization": header })

  # var confURL = @[provider, "url"].join(".")
  # confURL = if (url == ""): getConf(config, confURL) else: url

  # Generate API request
  var api = @[confURL, confEndpoint].join("")
  api = replace(api, "{{user}}", user)

  let payload = parseJson(client.getContent(api))
  # let payload = parseJson("[{\"key\": \"API calls suspended because of rate limiting\"}]")
  for i in countup(0, payload.len - 1):
    let key = to(payload[i]["key"], string)
    add(keys, key)

  return keys