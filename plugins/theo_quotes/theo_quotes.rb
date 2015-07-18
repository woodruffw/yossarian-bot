#  -*- coding: utf-8 -*-
#  theo_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Theo De Raadt quotes for yossarian-bot.
#  theo_quotes.txt generated from Plan9Front's `theo`.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'yaml'

require_relative '../yossarian_plugin'

class TheoQuotes < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	QUOTES_FILE = File.expand_path(File.join(File.dirname(__FILE__), 'theo_quotes.txt'))
	@@quotes = File.readlines(QUOTES_FILE)

	def usage
		'!theo [nick] - Fetch a random Theo De Raadt quote and direct it at a nickname if given.'
	end

	def match?(cmd)
		cmd =~ /^(!)?theo$/
	end

	match /theo$/, method: :theo_quote

	def theo_quote(m)
		m.reply @@quotes.sample, true
	end

	match /theo (\S+)/, method: :theo_quote_nick, strip_colors: true

	def theo_quote_nick(m, nick)
		if m.channel.users.has_key?(User(nick))
			quote = @@quotes.sample

			m.reply "#{nick}: #{quote}"
		else
			m.reply "I don\'t see #{nick} in this channel.", true
		end
	end
end
