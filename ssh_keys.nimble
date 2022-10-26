# Package

version       = "0.1.0"
author        = "Benny Michaels"
description   = "Keep ~/.ssh/authorized_keys of a server in sync with public SSH keys"
license       = "ISC"
srcDir        = "source"
namedBin      = {"main": projectName().replace("_", "-")}.toTable()
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

# ! Only supports UNIX systems for now
task link, "Link ./bin/" & projectName().replace("_", "-") & " to $NIMBLEDIR/bin/" & projectName().replace("_", "-"):
  var buildBinary = getCurrentDir()
  buildBinary.add("/bin/")
  buildBinary.add(projectName().replace("_", "-"))
  exec("ln -s " & buildBinary & " " & getLocalBinPath())

task unlink, "Remove $NIMBLEDIR/bin/" & projectName().replace("_", "-"):
  rmFile(getLocalBinPath())
