import
  commands/add,
  commands/config,
  commands/install,
  commands/remove,
  commands/sync,
  utils/consts

when isMainModule:
  import cligen
  include cligen/mergeCfgEnv

  const nimbleFile = staticRead "../ssh_keys.nimble"
  let docLine = nimbleFile.fromNimble("description") & "\n\n\n"

  when defined(versionGit):
    const vsn = staticExec "git describe --tags HEAD"
    clCfg.version = vsn
  else:
    clCfg.version = nimbleFile.fromNimble "version"

  dispatchMulti(
    [ "multi", cmdName="ssh-keys", doc = docLine ],
    [addAuthorizedUser, cmdName="add"],
    [setOrGetConfig, cmdName="config"],
    [installService, cmdName="install"],
    [removeAuthorizedUser, cmdName="remove"],
    [syncAuthorizedUsers, cmdName="sync"]
  )
