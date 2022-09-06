yossarian-bot
=============

![license](https://raster.shields.io/badge/license-MIT%20with%20restrictions-green.png)

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
* ...and [much more](COMMANDS.md)!

## Installation

First, clone the repo and install `yossarian-bot`'s dependencies:

```bash
$ git clone https://github.com/woodruffw/yossarian-bot
$ cd yossarian-bot
$ bundle install
```

If you get errors during the bundle installation process, make sure that you're
using Ruby 2.7 and have Ruby's development headers installed. You may need them
from your package manager. Earlier versions of Ruby *might* work, but are
not guaranteed or tested.

`yossarian-bot` also requires API keys for several services. Make sure that
they are exported to the environment (or set in the configuration) as follows:

* Wolfram|Alpha - `WOLFRAM_ALPHA_APPID_KEY`
* Weather Underground - `WUNDERGROUND_API_KEY`
* WeatherStack - `WEATHERSTACK_API_KEY`
* Merriam-Webster - `MERRIAM_WEBSTER_API_KEY`
* YouTube (v3) - `YOUTUBE_API_KEY`
* Last.fm - `LASTFM_API_KEY`, `LASTFM_API_SECRET`
* Open Exchange Rates - `OEX_API_KEY`
* Giphy - `GIPHY_API_KEY`
* BreweryDB - `BREWERYDB_API_KEY`
* AirQuality - `AIRNOW_API_KEY`
* OMDB - `OMDB_API_KEY`

Additionally, the `fortune` utility must be present in order for Unix fortunes
to work correctly. Some package managers also provide the `fortunes`,
`fortunes-off`, and `fortunes-bofh-excuses` packages for additional fortune
messages.

### Running

Once all dependencies are installed, `yossarian-bot` can be run as follows:

```bash
$ ruby bot-control.rb start
$ # OR:
$ ruby yossarian-bot.rb # not run in background
```

### Using Docker

```bash
docker build -t yossarian-bot:latest .
docker run -v $PWD/config.yml:/config.yml yossarian-bot
```

## Using the bot

### Configuration Options

`yossarian-bot` is configured via a YAML file named *config.yml*.

Look at [the example config.yml](config.yml.example) to see a list of optional
and required keys.

### Commands

There are a bunch of commands that `yossarian-bot` accepts. You can
see a complete list in the [COMMANDS](COMMANDS.md) file.

### Matches

`yossarian-bot` matches all HTTP[S] links and messages the title of the linked
HTML page. This feature can be disabled by adding `LinkTitling` to the server's
`disabled_plugins` array in `config.yml`.

Messages of the form `s/(.+)/(.+)` are also matched, and the first pattern
matched is applied to the user's last previous message, with the second match
replacing it. For example, a typo like "this is a setnence" can be corrected
with `s/setnence/sentence`. This feature can be disabled by adding
`RegexReplace` to the server's `disabled_plugins` array in `config.yml`.

## Contributing

Contributions to `yossarian-bot` are welcomed and appreciated.

If you're writing a plugin, check out the
[quick style guide](WRITING_PLUGINS.md) to writing plugins for `yossarian-bot`.

If you'd like to contribute but don't have any contributions in mind, check out
the [open issues](https://github.com/woodruffw/yossarian-bot/issues?q=is%3Aopen+is%3Aissue).
They're regularly updated with things that can be fixed, improved, and added.

## License

`yossarian-bot` is licensed under a restricted modification of the MIT license.

For the exact terms, see the [license](LICENSE) file.
