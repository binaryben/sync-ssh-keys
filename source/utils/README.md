# Logging

A simplistic logger has been written for this project. To use it, `import utils/logger` and then:

```
var log = newLogger("scope")
```

`scope` should be something that identifies where the logs are generated from - usually the name of the file without the extension works well for this.

## Basic usage

Now call the `SimpleLogger` methods on the new log instance:

```
log.debug("")
log.info("")
log.console("")
log.notice("")
log.warn("")
log.error("")
log.critical("")
log.error("")
log.alert("")
log.panic("")
```

## Logging tasks

There are some methods for logging the start and end of tasks to the console for user feedback.

```
log.task("")
log.success("")
log.failure("")
```

The `log.task` method only logs to the console. It's a convenience method to show the user something is happening.

If configured, the `log.success` and `log.failure` methods will log the event to system logs with a INFO or ERROR level respectively.

## Inspiration

The logger written for this is very basic and could be expanded. Inspiration can be found here:

* [Omnilog](https://github.com/nim-appkit/omnilog)
* [Syslog Levels and Formatting](https://www.pcwdld.com/syslog-trap-levels)
* [Chronicles](https://github.com/status-im/nim-chronicles)
* [Nim Morelogging](https://github.com/FedericoCeratto/nim-morelogging)
* [kslog](https://github.com/c-blake/kslog)
* [Logit](https://github.com/Miqueas/Logit)
* [nimDbg](https://github.com/enthus1ast/nimDbg)