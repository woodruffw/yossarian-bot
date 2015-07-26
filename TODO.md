TODO
====

## Core

* Make a yossarian_bot.rb a YossarianBot class that encapsulates everything
as an object instead of the current imperative approach.
* Make plugin management more granular (per-channel)
* ~~Expand configuration file to remove the need for argument flags~~
* Research better ways to connect to multiple networks besides spawning new
Cinch instances/Threads.
* ~~Reduce/remove any remaining global variables~~
* ~~Make blacklisting less awful (no monkey patch or global variable).~~

## Plugins

* ~~CTCPVersion currently listens for all CTCP messages, and then filters them
for 'VERSION'. This causes two bugs: `!ver yossarian-bot` doesn't work, and
users with multiple CTCP VERSION messages set can spam the channel via
`yossarian-bot`.~~
* There are (probably) URL encoding bugs in some of the web-based plugins.
* ~~YouTubeSearch relies on a now-deprecated API and needs to be updated to
continue working.~~
* GoogleTranslate also relies on a now-deprecated API and may need to be updated
or switched to a non-paid service.
* There are probably race conditions in some of the plugins.
* LastSeen should probably be rewritten/changed to be persistent across bot
reboots.
* Fix case sensitivity in plugins that use nicks. IRC isn't case sensitive, so
the bot shouldn't be.
* Cleverbot appears to have changed its interface, breaking the gem that the
Cleverbot plugin uses.
* CustomTriggers should be able to accept sanitized/safe regular expressions.
* HAL should learn on a per-channel basis and continuously save its brain.
* Make LinkTitling handle certain URLs with greater detail. For example, YouTube
URLs should be "titled" be video statistics, Amazon URLs with price, vendors,
etc.

## New Plugin Ideas

* [Systems Research Topic Generator](http://dept.cs.williams.edu/~barath/systems-topic-generator.html)
* [Crypto Research Topic Generator](http://cseweb.ucsd.edu/~mihir/crypto-topic-generator.html)
* [CS Research Topic Generator](https://www.cs.purdue.edu/homes/dec/essay.topic.generator.html)
