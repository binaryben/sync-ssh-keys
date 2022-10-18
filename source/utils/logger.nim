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

  MessageStyle = enum
    none = 0
    bright = styleBright
    dim = styleDim


proc newLogger * (scope: string, level: SyslogLevel = INFO, console: bool = true): SimpleLogger =
  new result
  result.scope = @[binName, scope].join(":")
  result.level = level
  result.console = console
  result.taskRunning = false

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
  style: MessageStyle = none,
): void {.base.} =
  if (self.console):
    stdout.styledWrite(fgPrefix, bgPrefix, prefix)
    if(style == bright):
      stdout.styledWriteLine(fgMessage, styleBright, message)
    elif(style == dim):
      stdout.styledWriteLine(fgMessage, styleDim, message)
    else:
      stdout.styledWriteLine(fgMessage, message)

method log (
  self: SimpleLogger,
  level: SyslogLevel,
  message: string,
  prefix: string = "",
  fgPrefix: ForegroundColor = fgDefault,
  bgPrefix: BackgroundColor = bgDefault,
  fgMessage: ForegroundColor = fgDefault,
  style: MessageStyle = none,
): void {.base.} =
  if(level <= self.level):
    self.print(level, prefix, message, fgPrefix, bgPrefix, fgMessage, style)

################################################################

method panic * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "☠️  "
  self.log(PANIC, message, prefix, fgMessage=fgMagenta, style=bright)

method alert * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "🚨 "
  self.log(ALERT, message, prefix, fgMessage=fgMagenta, style=bright)

method critical * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "🔥 "
  self.log(CRITICAL, message, prefix, fgMessage=fgRed, style=bright)

method error * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "⛔️ "
  self.log(ERROR, message, prefix, fgMessage=fgRed, style=bright)

method warn * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "⚠️  "
  self.log(WARN, message, prefix, fgMessage=fgYellow, style=bright)

method notice * (self: SimpleLogger, message: string): void {.base.} =
  const prefix = "ℹ️  "
  self.log(NOTICE, message, prefix, fgMessage=fgBlue, style=bright)

################################################################

# * SimpleLogger.info and SimpleLogger.console both = SyslogLevel.INFO
# Only difference is the console method will only write to the console

method info * (self: SimpleLogger, message: string): void {.base.} =
  self.log(INFO, message)

method console * (self: SimpleLogger, message: string): void {.base.} =
  self.log(INFO, message)

# * Similarly, the task methods (task, success & failure) all = SyslogLevel.INFO
# The task method will only write to the console
# The success and failure methods will write to both

method task * (self: SimpleLogger, message: string): void {.base.} =
  self.taskRunning = true
  self.log(INFO, message, prefix="⏳ ")

method success * (self: SimpleLogger, message: string): void {.base.} =
  if(self.taskRunning):
    cursorUp 1
    stdout.eraseLine()
    self.taskRunning = false
  self.log(INFO, message, prefix="✔  ", fgPrefix=fgGreen, style=dim)

method failure * (self: SimpleLogger, message: string): void {.base.} =
  if(self.taskRunning):
    cursorUp 1
    stdout.eraseLine()
    self.taskRunning = false
  self.log(INFO, message, prefix="✘  ", fgPrefix=fgRed, style=dim)

################################################################

method debug * (self: SimpleLogger, message: string): void {.base.} =
  self.log(DEBUG, message)
