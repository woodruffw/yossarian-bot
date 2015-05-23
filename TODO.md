TODO
====

## Core

* Make plugin management more granular (per-channel)
* Expand configuration file to remove the need for argument flags
* Research better ways to connect to multiple networks besides spawning new
Cinch instances/Threads.
* Reduce/remove any remaining global variables
* ~~Make blacklisting less awful (no monkey patch or global variable).~~

## Plugins

* ~~CTCPVersion currently listens for all CTCP messages, and then filters them
for 'VERSION'. This causes two bugs: `!ver yossarian-bot` doesn't work, and
users with multiple CTCP VERSION messages set can spam the channel via `yossarian-bot`.~~
* There are (probably) URL encoding bugs in some of the web-based plugins.
* ~~YouTubeSearch relies on a now-deprecated API and needs to be updated to
continue working.~~
* GoogleTranslate may also rely on a now-deprecated API and may need to be updated
or switched to a non-paid service.
* There are problem race conditions in some of the plugins.
* LastSeen should probably be rewritten/changed to be persistent across bot
reboots.

