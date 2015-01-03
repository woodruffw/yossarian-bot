yossarian-bot
=============

An entertaining IRC bot.

## Features:
* Unix fortunes (`fortune` must be present)
* Catch-22 quotes
* Public and private messages between users (through the bot)
* UrbanDictionary queries
* Wolfram|Alpha queries
* Weather updates
* ...and more!

## Running the bot

### Dependencies:
`yossarian-bot` depends on the `cinch`, `json`, `nokogiri`, `wolfram` and
`wunderground` gems.

You must also have API keys for the Wolfram Alpha and Weather Underground
APIs, exported to `WOLFRAM_ALPHA_APPID_KEY` and `WUNDERGROUND_API_KEY` 
respectively.

Additionally, the `fortune` utility must be present in order for Unix fortunes
to work correctly.

### Installation
Once all dependencies (see above) are installed, simply clone the repo and
run `yossarian-bot.rb`:

```bash
$ git clone https://github.com/woodruffw/yossarian-bot
$ cd yossarian-bot
$ ruby yossarian-bot.rb 'irc.example.net' '#chan1,#chan2'
```

## Using the bot

`yossarian-bot` prefixes its commands with `!`:

* `!help` - Message the caller with a list of accepted commands.
* `!bots` (or `[!:]bots`) - Report in as a robot.
* `!author` - Message the author's name.
* `!botver` - Message the version of `yossarian-bot` currently running.
* `!src` - Message a link to the bot's source code.
* `!fortune` - Message a Unix fortune.
* `!pmsg <user> <message>` - Private message the given user.
* `!ud <word>` - Look up the given word on UrbanDictionary.
* `!wa <query>` - Ask Wolfram|Alpha about something.
* `!w <location>` - Get the weather from Wunderground.

In addition to these commands, `yossarian-bot` also matches all HTTP[S] links
and messages the title of the linked HTML page.
