# Package

version       = "0.1.0"
author        = "Benny Michaels"
description   = "Keep ~/.ssh/authorized_keys of a server in sync with public SSH keys"
license       = "ISC"
srcDir        = "src"
bin           = @["sync_ssh_keys"]


# Dependencies

requires "nim >= 1.6.8"
