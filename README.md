yossarian-bot
=============

An entertaining IRC bot that's easy to extend.

## Features:
* Simple real-time administration.
* Unix fortunes (`fortune` must be present)
* Catch-22 quotes
* UrbanDictionary queries
* Wolfram|Alpha queries
* Smart weather queries (Wunderground)
* Google searches
* YouTube searches
* ROT13 message "encryption"
* Magic 8 Ball queries
* Dictionary queries (Merriam-Webster)
* Cleverbot discussions
* Channel 'seen' log
* Link compression (TinyURL)
* ...and more!

## Running the bot

### Dependencies:
`yossarian-bot` depends on the `cinch`, `json`, `nokogiri`, `wolfram`,
`wunderground`, `xml`, `daemons`, `cleverbot-api`, `xkcd`, and `time_difference`
gems.

To install them:

```bash
$ sudo gem install cinch json nokogiri wolfram wunderground libxml-ruby daemons cleverbot-api xkcd time_difference
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

### Command-Line Options

The first and second arguments are mandatory. The first argument is the server
domain (e.g. `irc.freenode.net`), and the second argument is a comma-separated
list of channels to join on that server (e.g. `#chan1,#chan2`).

All other arguments are optional:

* `-a`/`--admins 'nick1,nick2'` - Set administrator(s) for the bot, separated by commas. If this flag is not provided, the `!admin` command will not work for any user.
* `-t`/`--no-link-titles` - Disable link titling.
* `-s`/`--no-seen` - Disable the `!seen` command.
* `-r`/`--no-regex-replace` - Disable `sed`-like typo replacement.
* `-i`/`--no-intros` - Disable custom user intros.
* `-q`/`--no-quotes` - Disable user quote collection.

`yossarian-bot` has two usage cases: commands and matches.

### Commands

There are a bunch of commands that `yossarian-bot` accepts. You can
see a complete list in the [COMMANDS](./COMMANDS.md) file.

### Matches

`yossarian-bot` matches all HTTP[S] links
and messages the title of the linked HTML page. This feature can be disabled
with the `-n`/`--no-link-titles` flag.

Messages of the form `s/(.+)/(.+)` are also matched, and the first pattern
matched is applied to the user's last previous message, with the second match
replacing it. For example, a typo like "this is a setnence" can be corrected
with `s/setnence/sentence`. This feature can be disabled with the
`-r`/`--no-regex-replace` flag.

## License

`yossarian-bot` is licensed under the MIT License.

For the exact terms, see the [license](./LICENSE) file.
