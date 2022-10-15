import os
import cligen
import add
import config
import install
import remove
import sync

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
