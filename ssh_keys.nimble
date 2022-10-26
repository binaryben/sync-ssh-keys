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

proc getLocalBinDir(): string =
  var localBinPath: string
  var defaultNimblePath = getEnv("HOME")
  var defaultLocalPath = getEnv("HOME")

  defaultNimblePath.add("/.nimble")
  defaultLocalPath.add("/.local")

  if (existsEnv("NIMBLEDIR") and dirExists(getEnv("NIMBLEDIR"))):
    localBinPath = getEnv("NIMBLEDIR")
  elif (dirExists(defaultNimblePath)):
    localBinPath = defaultNimblePath
  else:
    localBinPath = defaultLocalPath

  localBinPath.add("/bin/")

  return localBinPath

proc getLocalBinPath(): string =
  return getLocalBinDir() & projectName().replace("_", "-")

before build:
  let localBinPath = getLocalBinPath()
  if(fileExists(localBinPath)):
    echo("   Removing ", localBinPath)
    rmFile(localBinPath)

after build:
  if(dirExists(getLocalBinDir())):
    let localBinPath = getLocalBinPath()
    var buildBinary = "./bin/"
    buildBinary.add(projectName().replace("_", "-"))
    echo("    Copying ", buildBinary, " to ", localBinPath)
    cpFile(buildBinary, localBinPath)