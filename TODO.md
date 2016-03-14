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
* Turn the bot into a gem?
* Move documentation (COMMANDS.md) to a dedicated site?

## Core

* Make a `yossarian_bot.rb` a `YossarianBot` class that encapsulates everything
as an object instead of the current imperative approach.
* Make plugin management more granular (per-channel)

## Plugins

* Add an `!admin update` or something similar to pull in updated plugins
instead of restarting the bot.
* Improve DRYness of all plugins (methods for common operations instead of
repeating self for each `match`).
* There are (probably) URL encoding bugs in some of the web-based plugins.
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
* CodeEval should use the `ruby-eval-in` gem for DRYness.

## New Plugin Ideas

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
* Flight data/plane lookup ([Flightaware?](http://flightaware.com/commercial/flightxml/))
* [MeetBot](https://wiki.debian.org/MeetBot)-like plugin
* "Now Reading" plugin (Goodreads)
* WHOIS query plugin
* [Have I Been Pwned? API](https://haveibeenpwned.com/API/v2)
