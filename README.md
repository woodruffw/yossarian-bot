yossarian-bot
=============

An entertaining IRC bot.

## Features:
* Unix fortunes (`fortune` must be present)
* Catch-22 quotes
* UrbanDictionary queries
* Wolfram|Alpha queries
* Weather updates
* Google searches
* Cleverbot
* ...and more!

## Running the bot

### Dependencies:
`yossarian-bot` depends on the `cinch`, `json`, `nokogiri`, `wolfram`,
`wunderground`, `xml`, `daemons`, and `cleverbot-api` gems.

To install them:

```bash
$ sudo gem install cinch json nokogiri wolfram wunderground libxml-ruby daemons cleverbot-api
$ # OR:
$ bundle install
```

`yossarian-bot` also requires API keys for several services. Make sure that
they are exported to the environment as follows:

* Wolfram|Alpha - `WOLFRAM_ALPHA_APPID_KEY`
* Weather Underground - `WUNDERGROUND_API_KEY`
* Merriam-Webster - `MERRIAM_WEBSTER_API_KEY`

Additionally, the `fortune` utility must be present in order for Unix fortunes
to work correctly.

### Installation
Once all dependencies (see above) are installed, simply clone the repo and
run `yossarian-bot.rb`:

```bash
$ git clone https://github.com/woodruffw/yossarian-bot
$ cd yossarian-bot
$ bundle install
$ ruby bot-control.rb start -- 'irc.example.net' '#chan1,#chan2'
$ # OR:
$ ruby yossarian-bot.rb 'irc.example.net' '#chan1,#chan2' # not run in background
```

## Using the bot

`yossarian-bot` prefixes its commands with `!`:

* `!help` (or `[.:]help`) - Message the caller with a list of accepted commands.
* `!bots` (or `[.:]bots`) - Report in as a robot.
* `!author` - Message the author's name.
* `!botver` - Message the version of `yossarian-bot` currently running.
* `!src` - Message a link to the bot's source code.
* `!fortune` - Message a Unix fortune.
* `!say <message>` - Make the bot say the given message.
* `!pmsg <user> <message>` - Private message the given user.
* `!ud <word>` - Look up the given word on UrbanDictionary.
* `!wa <query>` - Ask Wolfram|Alpha about something.
* `!w <location>` - Get the weather from Wunderground.
* `!g <search>` - Search Google.
* `!rot13 <message>` - "encrypt" a message with the ROT-13 cipher.
* `!8ball <question>` - ask the Magic 8 Ball a question.
* `!define <word>` - get the Merriam-Webster definiton of a word.
* `!cb <query>` - talk to CleverBot.

In addition to these commands, `yossarian-bot` also matches all HTTP[S] links
and messages the title of the linked HTML page.
