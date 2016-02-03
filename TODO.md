TODO
====

It might be worth reading [the style guide](WRITING_PLUGINS.md) before working
on some of these.

## Documentation/Meta

* There is currently a bounty on bugs that cause `yossarian-bot` to crash or
busy loop (causing a DoS). The first three reproducible bugs reported that
meet these requirements will receive free
[Club-Mates](https://en.wikipedia.org/wiki/Club-Mate).
* Document plugins/core better (YARD?)
* ~~Alphabetize [COMMANDS.md](COMMANDS.md) and plugins for better
organization.~~

## Core

* Make a `yossarian_bot.rb` a `YossarianBot` class that encapsulates everything
as an object instead of the current imperative approach.
* Make plugin management more granular (per-channel)
* ~~Expand configuration file to remove the need for argument flags~~
* Research better ways to connect to multiple networks besides spawning new
Cinch instances/Threads.
* ~~Reduce/remove any remaining global variables~~
* ~~Make blacklisting less awful (no monkey patch or global variable).~~

## Plugins

* Add an `!admin update` or something similar to pull in updated plugins
instead of restarting the bot.
* Improve DRYness of all plugins (methods for common operations instead of
repeating self for each `match`).
* ~~CTCPVersion currently listens for all CTCP messages, and then filters them
for 'VERSION'. This causes two bugs: `!ver yossarian-bot` doesn't work, and
users with multiple CTCP VERSION messages set can spam the channel via
`yossarian-bot`.~~
* There are (probably) URL encoding bugs in some of the web-based plugins.
* ~~YouTubeSearch relies on a now-deprecated API and needs to be updated to
continue working.~~
* GoogleTranslate also relies on a now-deprecated API and may need to be updated
or switched to a non-paid service.
[Here's a possible alternative.](http://mymemory.translated.net/doc/spec.php)
* There are probably race conditions in some of the plugins.
* LastSeen should probably be rewritten/changed to be persistent across bot
reboots.
* Fix case sensitivity in plugins that use nicks. IRC isn't case sensitive, so
the bot shouldn't be.
* Cleverbot appears to have changed its interface, breaking the gem that the
Cleverbot plugin uses.
* CustomTriggers should be able to accept sanitized/safe regular expressions.
* CustomTriggers should also be able to accept triggers with spaces.
* HAL should learn on a per-channel basis and continuously save its brain.
* Make LinkTitling handle certain URLs with greater detail. For example, YouTube
URLs should be "titled" be video statistics, Amazon URLs with price, vendors,
etc.
* Plugins need to be thoroughly tested for race conditions and side cases when
pulling data from web services.
* ~~ChannelAdmin should have a `!channel kickon <regex>` command that takes a
sanitized regex and kicks users who trigger it.~~ Taken care of in
ChannelModerator.

## New Plugin Ideas

* ~~[Systems Research Topic Generator](http://dept.cs.williams.edu/~barath/systems-topic-generator.html)~~
* ~~[Crypto Research Topic Generator](http://cseweb.ucsd.edu/~mihir/crypto-topic-generator.html)~~
* ~~[CS Research Topic Generator](https://www.cs.purdue.edu/homes/dec/essay.topic.generator.html)~~
* [Fake identity generator](https://fakena.me/random/)
* Channel greeter for new nicks (probably requires an extensive DB and
restriction system, maybe `use_opped`)
* Scraper for random [Dinosaur Comics](http://www.qwantz.com/index.php)
* [The proof is trivial!](http://www.theproofistrivial.com/)
* [Tech idea generator](http://bwasti.com/techideas)
* [Hacker News search](https://hn.algolia.com/api)
* [Location Information via Google Maps API](https://developers.google.com/places/web-service/)
* [Deepak Chopra Quote Generator](http://wisdomofchopra.com/)
* [ArXiv](http://arxiv.org/) paper search
* ~~[Reverse Phone Lookup](https://numverify.com/)~~
* Flight data/plane lookup ([Flightaware?](http://flightaware.com/commercial/flightxml/))
* [MeetBot](https://wiki.debian.org/MeetBot)-like plugin
* "Now Reading" plugin (Goodreads)
