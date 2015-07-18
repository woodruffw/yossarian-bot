#  -*- coding: utf-8 -*-
#  lennart_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Lennart Poettering quotes for yossarian-bot.
#  lennart_quotes.txt graciously collected by "rewt".
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'yaml'

require_relative '../yossarian_plugin'

class LennartQuotes < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	QUOTES_FILE = File.expand_path(File.join(File.dirname(__FILE__), 'lennart_quotes.txt'))
	@@quotes = File.readlines(QUOTES_FILE)

	def usage
		'!lennart [nick] - Fetch a random Lennart Poettering quote and direct it at a nickname if given.'
	end

	def match?(cmd)
		cmd =~ /^(!)?lennart$/
	end

	match /lennart$/, method: :lennart_quote

	def lennart_quote(m)
		m.reply @@quotes.sample, true
	end

	match /lennart (\S+)/, method: :lennart_quote_nick, strip_colors: true

	def lennart_quote_nick(m, nick)
		if m.channel.users.has_key?(User(nick))
			quote = @@quotes.sample

			m.reply "#{nick}: #{quote}"
		else
			m.reply "I don\'t see #{nick} in this channel.", true
		end
	end
end
