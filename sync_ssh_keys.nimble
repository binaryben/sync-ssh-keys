# Package

version       = "0.1.0"
author        = "Benny Michaels"
description   = "Keep ~/.ssh/authorized_keys of a server in sync with public SSH keys"
license       = "ISC"
srcDir        = "source"
bin           = @["sync_ssh_keys"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.6.8"
