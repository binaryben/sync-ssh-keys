import
  std/httpclient,
  std/json,
  strutils

proc syncAuthorizedUsers* (
  args: seq[string],
): int =
  var client = newHttpClient()
  let user = parseJson(client.getContent("http://api.github.com/users/binaryben"))
  var username = to(user["login"], string)
  username = replace(username, "\"", "")
  echo("Public keys for @", username, " (", user["name"], ")\n")

  let keys = parseJson(client.getContent("http://api.github.com/users/binaryben/keys"))
  for i in countup(0, keys.len - 1):
    echo(keys[i]["key"], "\n")

  return 1