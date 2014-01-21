Email OmniFocus Task Completion Report
========

## Synopsis

This AppleScript retrieves a list of [OmniFocus](http://www.omnigroup.com/omnifocus) tasks completed yesterday or today. It then sends an email report of those completed tasks. This script is based on the following original scripts: [Ben Waldie's script](http://www.tuaw.com/2013/04/15/applescripting-omnifocus-send-completed-task-report-to-evernot/) and [Justin Lancy's](http://veritrope.com/code/write-todays-completed-tasks-in-omnifocus-to-a-text-file/).

## Motivation

In a conversation with a friend who is learning how to use OmniFocus, it was suggested that a daily summary of one's work accomplished each day -- here, in the form of a nightly email report -- would provide a useful perspective on one's effort and progress. Hence, this script.

## Installation

Three properties need to be configured at the top of the script: `toAddress`, `fromAddress`, and `theReportScope`. The script can be used as any other AppleScript (called by AppleScript Editor.app, run from the command line, etc). Of note, this script can easily be called on schedule by using the following [Cronnix](https://code.google.com/p/cronnix/) crontab command: `/usr/bin/osascript path/to/Email OmniFocus Task Completion Report.scpt`

## License

This is free and unencumbered software released into the public domain. [Full license here](https://github.com/pgorrindo/Email-OmniFocus-Task-Completion-Report/blob/master/UNLICENSE). For more information, please refer to [unlicense.org](http://unlicense.org/).

