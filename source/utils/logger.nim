from logging import Logger
import
  std/strutils,
  std/terminal

import /consts

type
  SyslogLevel* = enum
    PANIC = 0
    ALERT = 1
    CRITICAL = 2
    ERROR = 3
    WARN = 4
    NOTICE = 5
    INFO = 6
    DEBUG = 7

  SimpleLogger = ref object of Logger
    applicationName: string
    scope: string
    level: SyslogLevel
    console: bool
    taskRunning: bool
    addedLine: bool
    count: int

  MessageStyle = enum
    styleNone = 0
    bright = styleBright
    dim = styleDim

  SuppressLog = enum
    file,
    tty,
    noSuppress

  ConsoleSpace = enum
    top,
    bottom,
    both,
    noSpace

proc newLogger * (scope: string, level: SyslogLevel = INFO, console: bool = true): SimpleLogger =
  new result
  result.scope = @[binName, scope].join(":")
  result.level = level
  result.console = console
  result.taskRunning = false
  result.count = 0

# Example format:
# Jan 18 03:02:42: %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0, changed state to down

# method save (self: SimpleLogger, level: SyslogLevel, message: string): void {.base.} =
#   echo(message)

method print (
  self: SimpleLogger,
  level: SyslogLevel,
  prefix: string,
  message: string,
  fgPrefix: ForegroundColor = fgDefault,
  bgPrefix: BackgroundColor = bgDefault,
  fgMessage: ForegroundColor = fgDefault,
  style: MessageStyle = styleNone,
  space: ConsoleSpace = noSpace,
): void {.base.} =
  if (self.console):
    if (space == top or space == both and self.count != 0):
      if (not self.addedLine): echo("")

    if (prefix != ""):
      var alignedPrefix = prefix
      add(alignedPrefix, " ")
      stdout.styledWrite(fgPrefix, bgPrefix, alignedPrefix)
    else:
      stdout.styledWrite(fgPrefix, bgPrefix, prefix)
    if(style == bright):
      stdout.styledWriteLine(fgMessage, styleBright, message)
    elif(style == dim):
      stdout.styledWriteLine(fgMessage, styleDim, message)
    else:
      stdout.styledWriteLine(fgMessage, message)

    if (space == bottom or space == both):
      echo("")
      self.addedLine = true
    else:
      self.addedLine = false

    self.count = self.count + 1

method log (
  self: SimpleLogger,
  level: SyslogLevel,
  message: string,
  prefix: string = "",
  fgPrefix: ForegroundColor = fgDefault,
  bgPrefix: BackgroundColor = bgDefault,
  fgMessage: ForegroundColor = fgDefault,
  style: MessageStyle = styleNone,
  task: bool = false,
  suppress: SuppressLog = noSuppress,
  space: ConsoleSpace = noSpace,
): void {.base.} =
  if(level <= self.level and suppress != SuppressLog.tty):
    self.print(
      level,
      prefix,
      message,
      fgPrefix,
      bgPrefix,
      fgMessage,
      style,
      space=space,
    )
  self.taskRunning = task

################################################################

method panic * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "☠️ "
  self.log(PANIC, message, prefix, fgMessage=fgMagenta, style=bright, space=both)

method alert * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "🚨"
  self.log(ALERT, message, prefix, fgMessage=fgMagenta, style=bright, space=both)

method critical * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "🔥"
  self.log(CRITICAL, message, prefix, fgMessage=fgRed, style=bright, space=both)

method error * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "⛔️"
  self.log(ERROR, message, prefix, fgMessage=fgRed, style=bright, space=both)

method warn * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "⚠️ "
  self.log(WARN, message, prefix, fgMessage=fgYellow, style=bright, space=both)

method notice * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "ℹ️ "
  self.log(NOTICE, message, prefix, fgMessage=fgBlue, style=bright)

method info * (self: SimpleLogger, message: string): void {.base.} =
  self.log(INFO, message)

################################################################

# * console, header and title all = SyslogLevel.INFO
# None of these methods save to persisted log files

method console * (self: SimpleLogger, message: string): void {.base.} =
  self.log(INFO, message, suppress=SuppressLog.file)

method header * (self: SimpleLogger, message: string): void {.base.} =
  self.log(INFO, message, style=bright, suppress=SuppressLog.file, space=both)

method title * (self: SimpleLogger, message: string): void {.base.} =
  self.log(INFO, message, suppress=SuppressLog.file, space=both)

# * SimpleLogger.task and SimpleLogger.success = SyslogLevel.INFO
# * SimpleLogger.failure = SyslogLevel.ERROR
# The task method will only write to the console
# The success and failure methods will write to both

method task * (self: SimpleLogger, message: string): void {.base.} =
  self.log(INFO, message, prefix="⏳", task=true, suppress=SuppressLog.file)

method success * (self: SimpleLogger, message: string): void {.base.} =
  if(self.taskRunning):
    cursorUp 1
    stdout.eraseLine()
  self.log(INFO, message, prefix="✔ ", fgPrefix=fgGreen, style=dim)

method failure * (self: SimpleLogger, message: string): void {.base.} =
  if(self.taskRunning):
    cursorUp 1
    stdout.eraseLine()
  self.log(ERROR, message, prefix="✘ ", fgPrefix=fgRed, style=dim)

################################################################

method debug * (self: SimpleLogger, message: string): void {.base.} =
  self.log(DEBUG, message, prefix=self.scope, fgPrefix=fgMagenta, style=dim)
