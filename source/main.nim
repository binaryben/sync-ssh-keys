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
        dispatch addAuthorizedUser
      of "config":
        dispatch setOrGetConfig
      of "install":
        dispatch installService
      of "remove":
        dispatch removeAuthorizedUser
      of "sync":
        dispatch syncAuthorizedUsers
  else:
    dispatch syncAuthorizedUsers
