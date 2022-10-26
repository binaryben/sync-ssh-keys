import std/strutils

proc getBinName (): string =
  const nimbleFile = staticRead "../../ssh_keys.nimble"
  for line in nimbleFile.split("\n"):
    if line.startsWith("namedBin"):
      var name = line.split('=')
      name = name[1].split(':')
      name = name[1].split('}')
      result = name[0].strip()[1..^2]
      break

const binName * = getBinName()
