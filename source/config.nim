


proc setOrGetConfig* (
  config: string = "~/.ssh/authorized_users",
  output: string = "~/.ssh/authorized_keys",
  args: seq[string],
): int =
  echo "This is the config command"
  return 1