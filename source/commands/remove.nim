proc removeAuthorizedUser* (
  user: string = "",
  token: string = "",
  org: string = "",
  team: string = "",
  provider: string = "git",
  url: string = "https://api.github.com",
  endpoint: string = "/users/{{user}}/keys",
  args: seq[string],
): int =
  echo "This is the remove command"
  echo("user: ", user)
  echo("token: ", token)
  echo("org: ", org)
  echo("team: ", team)
  return 1