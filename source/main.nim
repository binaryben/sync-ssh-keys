import
  os, cligen
import
  add,
  config,
  install,
  remove,
  sync

when declared(paramStr):
  if paramCount() > 0:
    case paramStr(1):
      of "add":
        dispatch(addAuthorizedUser, cmdName="ssh-keys add")
      of "config":
        dispatch(setOrGetConfig, cmdName="ssh-keys config")
      of "install":
        dispatch(installService, cmdName="ssh-keys install")
      of "remove":
        dispatch(removeAuthorizedUser, cmdName="ssh-keys remove")
      of "sync":
        dispatch(syncAuthorizedUsers, cmdName="ssh-keys sync")
  else:
    dispatch(syncAuthorizedUsers, cmdName="ssh-keys sync")
