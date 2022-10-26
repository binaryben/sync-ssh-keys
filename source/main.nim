import
  commands/[add, config, install, list, push, remove, sync],
  utils/[consts, logger]

let log = newLogger("cli")
log.debug("all commands ready for dispatch")

const GlobalUsage = "${doc}\e[1mUSAGE\e[m\n" & """
  $command <command> [flags] [args]

""" & "\e[1mCOMMANDS\e[m" & """

$subcmds
""" & "\e[1mFLAGS\e[m" & """

  --help      Show help for a command
  --version   Show $command version

""" & "\e[1mEXAMPLES\e[m" & """

  λ $command install
  λ $command add --user=binaryben
  λ $command sync

""" & "\e[1mLEARN MORE\e[m" & """

  Use '$command help <command>' for more information about a command
  Read the docs at https://github.com/binaryben/sync-ssh-keys

""" & "\e[1mFEEDBACK\e[m" & """

  Open an issue at https://bnry.be/ssk-issues
  Request help at https://bnry.be/ssk-help
  Submit feature requests at https://bnry.be/ssk-idea"""

when isMainModule:
  import cligen
  import models/conf

  include cligen/mergeCfgEnv

  log.debug("ensuring local system is ready for config and use")
  ensureConfigExists()

  log.debug("generating help information")
  const nimbleFile = staticRead "../ssh_keys.nimble"
  let docLine = nimbleFile.fromNimble("description") & "\n\n\n"

  clCfg.helpSyntax = ""
  clCfg.hTabCols = @[ clOptKeys, clDescrip ]
  clCfg.useHdr = "${doc}\n\e[1mUSAGE\e[m\n  "

  log.debug("loading cligen with version information")
  var cfPlusVersion = clCfg

  when defined(versionGit):
    const vsn = staticExec "git describe --tags HEAD"
    log.debug("git tag found at compile time: " & vsn)
    cfPlusVersion.version = vsn
  else:
    const vsn = nimbleFile.fromNimble "version"
    log.debug("⚠️  no git tag found at compile time")
    log.debug("fallback to nimble file: " & vsn)
    cfPlusVersion.version = vsn

  log.debug("attempting to dispatch sub command now ...")
  dispatchMulti(
    [ "multi", cmdName=binName, doc=docLine, usage=GlobalUsage, short={ "version": 'V' }, cf=cfPlusVersion ],
    [addAuthorizedUser, cmdName="add", doc=AddDoc, help=AddHelp, usage=AddUsage ],
    [ configCommand, cmdName="config", doc=ConfigDoc, help=ConfigHelp, usage=ConfigUsage ],
    [ installCommand, cmdName="install", doc=InstallDoc, help=InstallHelp, usage=InstallUsage ],
    [ listCommand, cmdName="list", doc=ListDoc, help=ListHelp, usage=ListUsage ],
    [ pushCommand, cmdName="push", doc=PushDoc, help=PushHelp, usage=PushUsage ],
    [ removeCommand, cmdName="remove", doc=RemoveDoc, help=RemoveHelp, usage=RemoveUsage ],
    [ syncAuthorizedUsers, cmdName="sync" ]
  )
