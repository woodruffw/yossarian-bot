commands
=========

`yossarian-bot` accepts the following commands:

All commands are prefixed with `!`, or `.`/`:` in some cases.

* `!help [cmd]` (or `[.:]help`) - Message the caller with a list of accepted commands or help on a command.
* `!botinfo <key>` (or `[.:]botinfo`) - Retrieve information about the bot. Keys: ver, src, author.
* `!admin <commands>` - Administrate the bot with an authorized user. Accepted commands: enable|disable|list <plugin>, quit, say.
* `!src` (or `[.:]src`) - Message a link to the bot's source code.
* `!fortune` - Message a Unix fortune.
* `!ud <word>` - Look up the given word on UrbanDictionary.
* `!wa <query>` - Ask Wolfram|Alpha about something.
* `!w <location>` - Get the weather from Wunderground.
* `!g <search>` - Search Google.
* `!yt <search>` - Search YouTube.
* `!rot13 <message>` - "encrypt" a message with the ROT-13 cipher.
* `!8ball <question>` - ask the Magic 8 Ball a question.
* `!define <word>` - get the Merriam-Webster definiton of a word.
* `!cb <query>` - talk to CleverBot.
* `!seen <nick>` - check the last time `yossarian-bot` saw someone.
* `!turl <url>` - create a short link to the given url with TinyURL.
* `!gh <username>` - get statistics about a GitHub user.
* `!xkcd [search]` - get a random XKCD comic, or one related to a query.
* `!isitup <site>` - check whether or not a given site is currently online.
