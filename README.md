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

## Installation

First, clone the repo and install `yossarian-bot`'s dependencies:

```bash
$ git clone https://github.com/woodruffw/yossarian-bot
$ cd yossarian-bot
$ bundle install
```

`yossarian-bot` also requires API keys for several services. Make sure that
they are exported to the environment as follows:

* Wolfram|Alpha - `WOLFRAM_ALPHA_APPID_KEY`
* Weather Underground - `WUNDERGROUND_API_KEY`
* Merriam-Webster - `MERRIAM_WEBSTER_API_KEY`
* YouTube (v3) - `YOUTUBE_API_KEY`

Additionally, the `fortune` utility must be present in order for Unix fortunes
to work correctly.

### Running

Once all dependencies are installed, `yossarian-bot` can be run as follows:

```bash
$ ruby bot-control.rb start
$ # OR:
$ ruby yossarian-bot.rb # not run in background
```

## Using the bot

### Configuration Options

`yossarian-bot` is configured via a YAML file named *config.yml*.

Look at [the example config.yml](config.yml.example) to see a list of optional and required
keys.

### Commands

There are a bunch of commands that `yossarian-bot` accepts. You can
see a complete list in the [COMMANDS](COMMANDS.md) file.

### Matches

`yossarian-bot` matches all HTTP[S] links
and messages the title of the linked HTML page. This feature can be disabled
with the `-n`/`--no-link-titles` flag.

Messages of the form `s/(.+)/(.+)` are also matched, and the first pattern
matched is applied to the user's last previous message, with the second match
replacing it. For example, a typo like "this is a setnence" can be corrected
with `s/setnence/sentence`. This feature can be disabled with the
`-r`/`--no-regex-replace` flag.

## Contributing

Contributions to `yossarian-bot` are welcomed and appreciated.

If you'd like to contribute but don't have any contributions in mind, check out
the [TODO](TODO.md) file. It contains a list of things that can be fixed,
improved, and added.

## License

`yossarian-bot` is licensed under the MIT License.

For the exact terms, see the [license](LICENSE) file.
