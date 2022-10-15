# Package

version       = "0.1.0"
author        = "Benny Michaels"
description   = "Keep ~/.ssh/authorized_keys of a server in sync with public SSH keys"
license       = "ISC"
srcDir        = "source"
namedBin      = {"main": "sync-ssh-keys"}.toTable()
binDir        = "bin"


# Dependencies

requires "nim >= 1.6.8"
requires "cligen >= 1.5.30"

# Copy binary to ~/.local/bin if it exists
# * NOTE: This follows XDG Base Directory Specification

before build:
  var localBinPath = getEnv("HOME")
  localBinPath.add("/.local/bin/sync-ssh-keys")
  if(fileExists(localBinPath)):
    echo "Removing copy of sync-ssh-keys from ~/.local/bin/"
    rmFile(localBinPath)

after build:
  var localBinPath = getEnv("HOME")
  localBinPath.add("/.local/bin/")
  if(dirExists(localBinPath)):
    echo("Copying to ~/.local/bin")
    localBinPath.add("sync-ssh-keys")
    cpFile("./bin/sync-ssh-keys", localBinPath)