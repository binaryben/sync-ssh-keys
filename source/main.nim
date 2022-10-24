import
  commands/add,
  commands/config,
  commands/install,
  commands/list,
  commands/push,
  commands/remove,
  commands/sync,
  utils/paths

const GlobalUsage = """${doc}USAGE
  $command <command> [flags] [args]

COMMANDS
$subcmds
FLAGS
  --help      Show help for a command
  --version   Show ssh-keys version

EXAMPLES
  λ $command install
  λ $command add --user=binaryben
  λ $command sync

LEARN MORE
  Use '$command help <command>' for more information about a command
  Read the docs at https://github.com/binaryben/sync-ssh-keys

FEEDBACK
  Open an issue at https://bnry.be/ssk-issues
  Request help at https://bnry.be/ssk-help
  Submit feature requests at https://bnry.be/ssk-idea"""

when isMainModule:
  import cligen
  import models/conf

  include cligen/mergeCfgEnv
  ensureConfigExists()

  const nimbleFile = staticRead "../ssh_keys.nimble"
  let docLine = nimbleFile.fromNimble("description") & "\n\n\n"

  when defined(versionGit):
    const vsn = staticExec "git describe --tags HEAD"
    clCfg.version = vsn
  else:
    clCfg.version = nimbleFile.fromNimble "version"

  clCfg.helpSyntax = ""
  clCfg.hTabCols = @[ clOptKeys, clDescrip ]
  clCfg.useHdr = "${doc}\n*USAGE*\n  "

  dispatchMulti(
    [ "multi", cmdName=binName, doc=docLine, usage=GlobalUsage ],
    [addAuthorizedUser, cmdName="add", doc=AddDoc, help=AddHelp, usage=AddUsage ],
    [ configCommand, cmdName="config", doc=ConfigDoc, help=ConfigHelp, usage=ConfigUsage ],
    [ installCommand, cmdName="install", doc=InstallDoc, help=InstallHelp, usage=InstallUsage ],
    [ listCommand, cmdName="list", doc=ListDoc, help=ListHelp, usage=ListUsage ],
    [ pushCommand, cmdName="push", doc=PushDoc, help=PushHelp, usage=PushUsage ],
    [ removeCommand, cmdName="remove", doc=RemoveDoc, help=RemoveHelp, usage=RemoveUsage ],
    [ syncAuthorizedUsers, cmdName="sync" ]
  )
