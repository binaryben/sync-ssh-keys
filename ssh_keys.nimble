import std/strutils

# Package

packageName   = "sync-ssh-keys"
version       = "0.1.0-alpha"
author        = "Benny Michaels"
description   = "Keep ~/.ssh/authorized_keys of a server in sync with public SSH keys"
license       = "ISC"
srcDir        = "source"
namedBin      = {"main": "ssh-keys"}.toTable()
binDir        = "bin"

# Dependencies

requires "nim >= 1.6.8"
requires "cligen >= 1.5.30"

when defined(nimdistros):
  import distros
  foreignDep "openssl"

# Copy binary to ~/.local/bin if it exists
#[
  ! NOTE: This follows XDG Base Directory Specification
  * HINT: These procedures are available: https://nim-lang.org/docs/nimscript.html#12
]#

before build:
  var localBinPath: string
  var defaultBinName = projectName()
  var defaultNimblePath = getEnv("HOME")
  var defaultLocalPath = getEnv("HOME")

  defaultBinName = defaultBinName.replace("_", "-")
  defaultNimblePath.add("/.nimble")
  defaultLocalPath.add("/.local")

  if (existsEnv("NIMBLEDIR") and dirExists(getEnv("NIMBLEDIR"))):
    localBinPath = getEnv("NIMBLEDIR")
  elif (dirExists(defaultNimblePath)):
    localBinPath = defaultNimblePath
  else:
    localBinPath = defaultLocalPath

  localBinPath.add("/bin/")
  localBinPath.add(defaultBinName)

  if(fileExists(localBinPath)):
    echo("   Removing ", localBinPath)
    rmFile(localBinPath)

  putEnv("CLIGEN", "/Users/ben/.local/share/git/github.com/binaryben/sync-ssh-keys/config/cligenrc")

after build:
  var localBinPath: string
  var defaultBinName = projectName()
  var defaultNimblePath = getEnv("HOME")
  var defaultLocalPath = getEnv("HOME")

  defaultBinName = defaultBinName.replace("_", "-")
  defaultNimblePath.add("/.nimble")
  defaultLocalPath.add("/.local")

  if (existsEnv("NIMBLEDIR") and dirExists(getEnv("NIMBLEDIR"))):
    localBinPath = getEnv("NIMBLEDIR")
  elif (dirExists(defaultNimblePath)):
    localBinPath = defaultNimblePath
  else:
    localBinPath = defaultLocalPath

  localBinPath.add("/bin/")

  if(dirExists(localBinPath)):
    localBinPath.add(defaultBinName)
    var buildBinary = "./bin/"
    buildBinary.add(defaultBinName)
    echo("    Copying ", buildBinary, " to ", localBinPath)
    cpFile(buildBinary, localBinPath)