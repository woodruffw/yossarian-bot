PLUGIN GUIDE
============

`yossarian-bot`'s plugins are more or less ordinary
[Cinch](https://github.com/cinchrb/cinch) plugins, but with a few additional
tweaks. If you want to make sure that your plugin works optimally (and that
I'll merge it), you should follow these guidelines:

* The general outline of your plugin should look something like this:

```ruby
require 'specialmodule'
require 'anothermodule'

require_relative './yossarian_plugin'

class FooBar < YossarianPlugin
	include Cinch::Plugin
	use_blacklist
	use_auth # if you need to restrict commands to admins
	use_opped silent: true # if the bot needs to be an op

	def usage
		'!foo <bar> - Use foo with bar on baz.'
	end

	def match?(cmd)
		cmd =~ /^(!)?foo/
	end

	match /foo (.+)/, method: :foo, strip_colors: true

	def foo(bar)
		quux = baz(bar)
		m.reply quux, true
	end
end

```

* Plugin class names should be descriptive of their contents, but not overly
specific or generic. Acronyms should be preserved, not lowercased. The `BTC`
plugin is a good example of both of these rules - `Btc` and
`BitcoinPriceFetcher` are good examples of the **wrong** thing to do.

* You should **always** call `use_blacklist`. It makes sure that your plugin
obeys the list of ignored nicknames/hostmasks.

* You should call `use_auth` instead of reimplementing `yossarian-bot`'s
authentication system if your plugin needs to be restricted to only
authenticated admins. Be aware that `use_auth` restricts *all* commands in the
plugin.

* You should call `use_opped` if the bot needs to be a channel operator to
perform an action. Be aware that `use_opped` restricts *all* commands in the
plugin. The optional argument `silent:` takes a boolean that stops the bot from
complaining when asked to do a channel operation without being opped.

* You should (re)define `usage` and `match?(cmd)` to meet your plugin's
functionality and invocation, respectively. `yossarian-bot` uses these two
methods to provide helpful information via `!help`.

* Each `match` call should be right above the method it invokes.

* If invoked methods get input from the user, remember to `Sanitize()` it or
use `strip_colors: true` if that'll suffice. Web services do not generally like
color codes.

* When the invoked method responds to the user (and it always should), it
should *generally* highlight them. In other words, highlighting the user is the
correct behavior about 90% of the time. For output where a highlight would only
add clutter or confusion, this can be skipped. Good exmaples of this include
`UserQuotes` and `Fortune`.

* Make sure any output generated is sanitized, just as it came in (unless
the goal of the plugin is to add colors/codes). That means avoiding sending
ASCII BELs, SOHs, or any other characters that can cause unusual or unintended
behavior in either the bot or connected clients.
