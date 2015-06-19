COMMANDS
========

This is a list of commands accepted by `yossarian-bot`.

### Legend

* If a command takes prefix(es) besides `!`, they will be noted within braces (`{}`).
* An argument enclosed in `<>` is **mandatory**. Example: `<text>`
* An argument enclosed in `[]` is **optional**. Example: `[text]`.
* A bar (`|`) indicates a **choice**. For example, `<hello|bye>` indicates a
mandatory argument of **either** `hello` or `bye`.

### Commands

Command Syntax | Plugin class | Description | Working?
-------------- | ------------ | ----------- | -------
`{.!:}bots` | IBIP | Announce this bot to the channel. | Yes
`{.!:}help [cmd]` | CommandHelp | Announce general help or help on a specific command if provided. | Yes
`!ping` | Ping | Ping the bot for a timestamped response. | Yes
`!botinfo <key>` | BotInfo | Retrieve information about the bot. [See below](#botinfo). | Yes
`!admin <subcommand>` | BotAdmin | Administrate the bot with an authorized user. [See below](#admin). | Yes
`!fortune` | Fortune | Get a Unix fortune. | Yes
`!c22` | Catch22 | Get a Catch-22 quote. | Yes
`!ud <query>` | UrbanDictionary | Look up the given query on [UrbanDictionary](http://www.urbandictionary.com/). | Yes
`!wa <query>` | WolframAlpha | Ask [Wolfram\|Alpha](http://www.wolframalpha.com/) about something. | Yes
`!w <location>` | Weather | Get the weather for the given location from [Wunderground](https://www.wunderground.com/). | Yes
`!g <search>` | GoogleSearch | Search [Google](https://google.com). | Yes
`!tr <text>` | GoogleTranslate | Translate text to English with [Google Translate](https://translate.google.com). | Broken (API changed)
`!yt <search>` | YouTubeSearch | Search [YouTube](https://youtube.com). | Yes
`!ddg <search>` | DuckDuckGoSearch | Search [DuckDuckGo](https://duckduckgo.com)'s Zero Click Info database. | Yes
`!rot13 <text>` | Rot13 | "Encrypt" some text with the ROT-13 cipher. | Yes
`!8ball <question>` | Magic8Ball | Ask the Magic 8 Ball a question. | Yes
`!define <word>` | MerriamWebster | Get the [Merriam-Webster](http://www.merriam-webster.com/) definiton of a word. | Yes
`!cb <message>` | Cleverbot | Talk to [CleverBot](http://www.cleverbot.com/). | Broken (API changed)
`!megahal <message>` | HAL | Talk to MegaHAL. | Yes
`!seen <nick>` | LastSeen | Check the last time `yossarian-bot` saw someone. | Yes
`!turl <url>` | TinyURL | Create a short link to the given url with [TinyURL](http://tinyurl.com/). | Yes
`!gh <username>` | GitHubInfo | Get statistics about a [GitHub](https://github.com/) user. | Yes
`!xkcd [search]` | XKCDComics | Get a random [XKCD](http://xkcd.com/) comic, or one related to a search. | Yes
`!jerkcity` | Jerkcity | Get a random [Jerkcity](http://jerkcity.com/) comic. | Yes
`!isitup <site>` | IsItUp | Check whether or not a given site is currently online. | Yes
`!haste <text>` | Hastebin | Post text to [Hastebin](http://hastebin.com/). | Yes
`!slap <nick>` | Slap | Slap someone with a large trout. | Yes
`!zalgo <text>` | Zalgo | Summon Zalgo with some text. | Yes
`!taco` | TacoRecipes | Get a random taco recipe, courtesy of the [Taco Randomizer](http://taco-randomizer.herokuapp.com/). | Yes
`!rainbow <text>` | RainbowText | Vomit out rainbowified text. | Yes
`!flip <down|up> <text>` | FlipText | Flip text upside down or rightside up. | Yes
`!morse <text>` | MorseCode | Convert text to Morse Code. | Yes
`!insult [nick]` | ShakespeareanInsults | Generate a Shakespearean insult and direct it at a nickname if given. | Yes
`!luther [nick]` | LutherInsults | Get an insult from [Luther's Oeuvre](http://ergofabulous.org/luther/) and direct it at a nickname if given. | Yes
`!theo [nick]` | TheoQuotes | Get a random Theo De Raadt quote and direct it at a nickname if given. | Yes
`!lennart [nick]` | LennartQuotes | Get a random Lennart Poettering quote and direct it at a nickname if given. | Yes
`!cbsg` | CBSG | Spew some corporate bullshit from the [Corporate Bullshit Generator](http://cbsg.sourceforge.net/cgi-bin/live). | Yes
`!btc` | BTC | Get the current BTC - USD exchange rate from the [BitcoinAverage Price Index](https://bitcoinaverage.com/). | Yes
`!stock <symbol>` | StockQuotes | Retrieve a stock quote for the given ticker symbol. | Yes
`!wp` | WorldPopulation | Get the current world population estimate from the [US Census](https://www.census.gov/popclock/data/population/world). | Yes
`!rb <code>` | RubyEval | Evaluate some Ruby code on [eval.in](https://eval.in). | Yes
`!wiki <search>` | Wikipedia | Search [Wikipedia](http://en.wikipedia.org). | Yes
`!leet <text>` | LeetSpeak | Convert text to leetspeak. | Yes
`!intro <command>` | UserIntros | Manage the intro message for your nick. [See below](#intro). | Yes
`!quote [nick]` | UserQuotes | Retrieve a completely random quote, or a random quote from the given nick. | Yes
`!mail <nick> <message>` | UserMail | Send a message to a nick. Messages are delivered the next time the nick speaks. | Yes
`!trigger <command>` | CustomTriggers | Manage custom message replies and their triggers. [See below](#trigger). | Yes
`!ver <nick>` | CTCPVersion | Send a CTCP VERSION request to the given nick. | Yes

### `!botinfo` keys <a name="botinfo"></a>

The `!botinfo` command takes one of the following keys:

Key | Description
--- | ------
`ver` (or `version`) | Get `yossarian-bot`'s version.
`src` (or `source`) | Get a link to `yossarian-bot`'s source code.
`author` | Get `yossarian-bot`'s author.
`uptime` | Get `yossarian-bot`'s running time.
`chans` (or `channels`) | List the channels the bot is currently on.
`admins` | List the nicks of the admins currently registered to the bot.
`ignores` | List nicks currently ignored by the bot.

### `!admin` subcommands <a name="admin"></a>

In order to administrate the bot, your IRC nick must be authorized.
Authorized nicks are either defined in the bot's `config.yml` or
with the `!admin auth <nick>` command at runtime (by an extant admin).

The `!admin` command can take several subcommands:

Subcommand | Description
---------- | ----------
`plugin list` | List all plugins currently *available*. This includes *all* plugins visible to `yossarian-bot`, not just enabled ones.
`enable <plugin>` | Enable the given plugin. The plugin *must* be the *class name* of the plugin.
`disable <plugin>` | Disable the given plugin. Like `enable`, the given plugin must be a class name.
`quit` | Gracefully kill the bot. This is the preferred way to terminate `yossarian-bot`.
`auth <nick>` | Make the given nick an administrator.
`deauth <nick>` | Remove the given nick from the administrator list.
`join <channel>` | Join the given channel on the network.
`leave <channel>` | Leave the given channel on the network, if in it. `ignore <nick>` | Ignore messages and commands from nick.
`unignore <nick>` | Stop ignoring messages and commands from nick.
`say <channel> <message>` | Make the bot say the given message in the given channel.
`act <channel> <message>` | Make the bot act the given message in the given channel.

### `!intro` subcommands <a name="intro"></a>

Each nickname is allowed to have a single introduction per channel registered
with the bot, which will be said whenever that nickname is seen joining the
channel in question.

Subcommand | Description
---------- | ----------
`add <intro>` | Set your nick's introduction message to the given intro.
`rm` | Delete your nick's introduction message.
`show` | Show your nick's introduction message.

### `!trigger` subcommands <a name="trigger"></a>

The `!trigger` command takes one of three subcommands:

Subcommand | Description
---------- | ----------
`add <trigger> <response>` | Make the bot say the given response whenever the given trigger is typed.
`rm <trigger>` | Remove the given trigger and the response associated with it.
`list` | List all triggers currently stored by `yossarian-bot`. Responses are not listed for the sake of brevity.
