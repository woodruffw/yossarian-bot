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
`!fortune` | Fortune | Get a Unix fortune. | Yes
`!c22` | Catch22 | Get a Catch-22 quote. | Yes
`!ud <query>` | UrbanDictionary | Look up the given query on [UrbanDictionary](http://www.urbandictionary.com/). | Yes
`!wa <query>` | WolframAlpha | Ask [Wolfram|Alpha](http://www.wolframalpha.com/) about something. | Yes
`!w <location>` | Weather | Get the weather for the given location from [Wunderground](https://www.wunderground.com/). | Yes
`!g <search>` | GoogleSearch | Search [Google](https://google.com). | Yes
`!yt <search>` | YouTubeSearch | Search [YouTube](https://youtube.com). | Yes
`!ddg <search>` | DuckDuckGoSearch | Search [DuckDuckGo](https://duckduckgo.com)'s Zero Click Info database. | Yes
`!rot13 <text>` | Rot13 | "Encrypt" some text with the ROT-13 cipher. | Yes
`!8ball <question>` | Magic8Ball | Ask the Magic 8 Ball a question. | Yes
`!define <word>` | MerriamWebster | Get the [Merriam-Webster](http://www.merriam-webster.com/) definiton of a word. | Yes
`!cb <query>` | Cleverbot | Talk to [CleverBot](http://www.cleverbot.com/). | Broken
`!seen <nick>` | LastSeen | Check the last time `yossarian-bot` saw someone. | Yes
`!turl <url>` | TinyURL | Create a short link to the given url with [TinyURL](http://tinyurl.com/). | Yes
`!gh <username>` | GitHubInfo | Get statistics about a [GitHub](https://github.com/) user. | Yes
`!xkcd [search]` | XKCDComics | Get a random [XKCD](http://xkcd.com/) comic, or one related to a search. | Yes
`!jerkcity` | Jerkcity | Get a random [Jerkcity](http://jerkcity.com/) comic. | Yes
`!isitup <site>` | IsItUp | Check whether or not a given site is currently online. | Yes
`!haste <text>` | Hastebin | Post text to [Hastebin](http://hastebin.com/). | Yes
`!slap <nick>` | Slap | Slap someone with a large trout. | Yes
