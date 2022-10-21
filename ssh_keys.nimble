# Package

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
  var localBinPath = getEnv("HOME")
  localBinPath.add("/.local/bin/ssh-keys")
  if(fileExists(localBinPath)):
    echo "Removing copy of sync-ssh-keys from ~/.local/bin/"
    rmFile(localBinPath)

after build:
  var localBinPath = getEnv("HOME")
  localBinPath.add("/.local/bin/")
  if(dirExists(localBinPath)):
    echo("Copying to ~/.local/bin")
    localBinPath.add("ssh-keys")
    cpFile("./bin/ssh-keys", localBinPath)