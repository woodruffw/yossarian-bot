commands
=========

`yossarian-bot` accepts the following commands:

All commands are prefixed with `!`, or `.`/`:` in some cases.

* `!help [cmd]` (or `[.:]help`) - Message the caller with a list of accepted commands or help on a command.
* `!ping` - Ping the bot for a timestamped response.
* `!botinfo <key>` (or `[.:]botinfo`) - Retrieve <key> information about the bot. See below.
* `!admin <commands>` - Administrate the bot with an authorized user. See below.
* `!fortune` - Message a Unix fortune.
* `!c22` - Get a random Catch-22 quote.
* `!ud <query>` - Look up the given query on [UrbanDictionary](http://www.urbandictionary.com/).
* `!wa <query>` - Ask [Wolfram|Alpha](http://www.wolframalpha.com/) about something.
* `!w <location>` - Get the weather from [Wunderground](https://www.wunderground.com/).
* `!g <search>` - Search [Google](https://google.com).
* `!yt <search>` - Search [YouTube](https://youtube.com).
* `!rot13 <text>` - "Encrypt" some text with the ROT-13 cipher.
* `!8ball <question>` - Ask the Magic 8 Ball a question.
* `!define <word>` - Get the [Merriam-Webster](http://www.merriam-webster.com/) definiton of a word.
* `!cb <query>` - Talk to [CleverBot](http://www.cleverbot.com/).
* `!seen <nick>` - Check the last time `yossarian-bot` saw someone.
* `!turl <url>` - Create a short link to the given url with [TinyURL](http://tinyurl.com/).
* `!gh <username>` - Get statistics about a [GitHub](https://github.com/) user.
* `!xkcd [search]` - Get a random [XKCD](http://xkcd.com/) comic, or one related to a query.
* `!isitup <site>` - Check whether or not a given site is currently online.
* `!haste <text>` - Post text to [Hastebin](http://hastebin.com/).
* `!slap <nick>` - Slap someone with a large trout.
* `!zalgo <text>` - Summon Zalgo with some text.
* `!taco` - Get a random taco recipe, courtesy of the [Taco Randomizer](http://taco-randomizer.herokuapp.com/).
* `!rainbow <text>` - Vomit out rainbowified text.
* `!morse <text>` - Convert text to Morse code.
* `!insult [nick]` - Generate a Shakespearean insult and direct it at a nickname if given.
* `!luther [nick]` - Get an insult from [Luther's Oeuvre](http://ergofabulous.org/luther/) and direct it at a nickname if given.
* `!theo [nick]` - Get a random Theo De Raadt quote and direct it at a nickname if given.
* `!cbsg` - Spew some corporate bullshit from the [Corporate Bullshit Generator](http://cbsg.sourceforge.net/cgi-bin/live) and direct it at a nickname if given.
* `!btc` - Get the current BTC - USD exchange rate from the [BitcoinAverage Price Index](https://bitcoinaverage.com/)
* `!wp` - Get the current world population estimate from the [US Census](https://www.census.gov/popclock/data/population/world)
* `!rb <code>` - Evaluate some Ruby code on [eval.in](https://eval.in). 
* `!wiki <search>` - Search [Wikipedia](http://en.wikipedia.org).
* `!leet <text>` - Convert text to leetspeak.
* `![rm|show]intro <intro>` - Set an custom intro for your nick. Prefixing this command with `show` or `rm` shows or removes your intro, respectively.
* `!quote [nick]` - Retrieve a completely random quote, or a random quote from the given nick.
* `!trigger <command>` - Manage custom message replies and their triggers. See below.
* `!ver [nick]` - Send a CTCP VERSION request to the given nick.

### `!botinfo` keys

The `!botinfo` command takes one of the following keys:

* `!botinfo ver` (or `version`) - Get `yossarian-bot`'s version.
* `!botinfo src` (or `source`)- Get a link to `yossarian-bot`'s source.
* `!botinfo author` - Get `yossarian-bot`'s author.
* `!botinfo uptime` - Get `yossarian-bot`'s running time.
* `!botinfo chans` (or `channels`) - List the channels the bot is currently on.
* `!botinfo admins` - List the nicks of the admins currently registered to the bot.
* `!botinfo ignores` - List nicks currently ignored by the bot.

### `!admin` sub-commands

In order to administrate the bot, your IRC nick must be authorized.
Authorized nicks are either defined at execution with the `-a`/`--admins` flag
or with the `!admin auth <nick>` command at runtime (by an extant admin).

The `!admin` command can take several sub-commands:

* `!admin plugin list` - List all plugins currently *available*. This includes *all*
plugins visible to `yossarian-bot`, not just enabled ones.
* `!admin enable <plugin>` - Enable the given \<plugin\>. \<plugin\> *must* be the 
*class name* of the plugin, like `GoogleSearch` or `WolframAlpha`.
* `!admin disable <plugin>` - Disable the given \<plugin\>. Like `enable`,
the given <plugin> must be a class name.
* `!admin quit` - Gracefully kill the bot. This is the preferred way to terminate `yossarian-bot`
* `!admin auth <nick>` - Make \<nick\> an administrator.
* `!admin deauth <nick>` - Remove \<nick\> from the administrator list.
* `!admin join <channel>` - Join \<channel\> on the network.
* `!admin leave <channel>` - Leave \<channel\> on the network, if in it.
* `!admin ignore <nick>` - Ignore messages and commands from \<nick\>.
* `!admin unignore <nick>` - Stop ignoring messages and commands from \<nick\>.
* `!admin say <channel> <message>` - Make the bot say \<message\> in \<channel\>.
* `!admin act <channel> <message>` - Make the bot act \<message\> in \<channel\>.

### `!trigger` sub-commands

The `!trigger` command takes one of three sub-commands:

* `!trigger add <trigger> <response>` - Make the bot say \<response\> whenever \<trigger\> is typed.
* `!trigger rm <trigger>` - Remove \<trigger\> and the response associated with it.
* `!trigger list` - List all triggers currently stored by `yossarian-bot`. Responses are not listed for the sake of brevity.
