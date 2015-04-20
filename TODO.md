TODO
====

## Core

* Make plugin management more granular (per-channel)
* Expand configuration file to remove the need for argument flags
* Research better ways to connect to multiple networks besides spawning new
Cinch instances/Threads.
* Reduce/remove any remaining global variables

## Plugins

* CTCPVersion currently listens for all CTCP messages, and then filters them
for 'VERSION'. This causes two bugs: `!ver yossarian-bot` doesn't work, and
users with multiple CTCP VERSION messages set can spam the channel via `yossarian-bot`.
* There are (probably) URL encoding bugs in some of the web-based plugins.
