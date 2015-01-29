commands
=========

`yossarian-bot` accepts the following commands:

All commands are prefixed with `!`, or `.`/`:` in some cases.

* `!help [cmd]` (or `[.:]help`) - Message the caller with a list of accepted commands or help on a command.
* `!botinfo <key>` (or `[.:]botinfo`) - Retrieve <key> information about the bot. See below.
* `!admin <commands>` - Administrate the bot with an authorized user. See below.
* `!fortune` - Message a Unix fortune.
* `!c22` - Get a random Catch-22 quote.
* `!ud <word>` - Look up the given word on UrbanDictionary.
* `!wa <query>` - Ask Wolfram|Alpha about something.
* `!w <location>` - Get the weather from Wunderground.
* `!g <search>` - Search Google.
* `!yt <search>` - Search YouTube.
* `!rot13 <message>` - "Encrypt" a message with the ROT-13 cipher.
* `!8ball <question>` - Ask the Magic 8 Ball a question.
* `!define <word>` - Get the Merriam-Webster definiton of a word.
* `!cb <query>` - Talk to CleverBot.
* `!seen <nick>` - Check the last time `yossarian-bot` saw someone.
* `!turl <url>` - Create a short link to the given url with TinyURL.
* `!gh <username>` - Get statistics about a GitHub user.
* `!xkcd [search]` - Get a random XKCD comic, or one related to a query.
* `!isitup <site>` - Check whether or not a given site is currently online.
* `!intro <intro>` - Set an custom intro for your nick. Prefixing this command with `rm` removes the intro.

### `!botinfo` keys

The `!botinfo` command takes one of four keys:

* `!botinfo ver` (or `version`) - Get `yossarian-bot`'s version.
* `!botinfo src` (or `source`)- Get a link to `yossarian-bot`'s source.
* `!botinfo author` - Get `yossarian-bot`'s author.
* `!botinfo admins` - List the nicks of the admins currently registered to the bot.

### `!admin` sub-commands

In order to administrate the bot, your IRC nick must be authorized.
Authorized nicks are either defined at execution with the `-a`/`--admins` flag
or with the `!admin auth <nick>` command at runtime (by an extant admin).

The `!admin` command can take several sub-commands:

* `!admin list` - List all plugins currently *available*. This includes *all*
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
* `!admin say <message>` - Make the bot say \<message\>.
