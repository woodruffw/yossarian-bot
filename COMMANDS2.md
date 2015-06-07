COMMANDS
========

This is a list of commands accepted by `yossarian-bot`.

### Legend

* If a command takes prefix(es) besides `!`, they will be noted within braces.
* An argument enclosed in \<\> is **mandatory**.
* An argument enclosed in [] is **optional**.

### Commands

Command Syntax | Plugin class | Description | Working?
-------------- | ------------ | ----------- | -------
`{.!:}bots` | IBIP | Announce this bot to the channel. | Yes
`{.!:}help [cmd]` | CommandHelp | Announce general help or help on a specific command if provided. | Yes
`!ping` | Ping | Ping the bot for a timestamped response. | Yes
`!botinfo <key>` | BotInfo | Retrieve information about the bot. See below. | Yes
`!admin <commands>` | BotAdmin | Administrate the bot with an authorized user. See below. | Yes
`!fortune` | Fortune | Message a Unix fortune. | Yes
