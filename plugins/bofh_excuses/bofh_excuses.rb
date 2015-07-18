#  -*- coding: utf-8 -*-
#  bofh_excuses.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides BOFH excuses for yossarian-bot.
#  bofh_excuses.txt adapted from Jeff Ballard's BOFH Excuse Server:
#  http://pages.cs.wisc.edu/~ballard/bofh/
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative '../yossarian_plugin'

class BOFHExcuses < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	EXCUSES_FILE = File.expand_path(File.join(File.dirname(__FILE__), 'bofh_excuses.txt'))
	@@excuses = File.readlines(EXCUSES_FILE)

	def usage
		'!bofh [nick] - Fetch a random Bastard Operator From Hell excuse and direct it at a nickname if given.'
	end

	def match?(cmd)
		cmd =~ /^(!)?bofh$/
	end

	match /bofh$/, method: :bofh_excuse

	def bofh_excuse(m)
		m.reply @@excuses.sample, true
	end

	match /bofh (\S+)/, method: :bofh_excuse_nick, strip_colors: true

	def bofh_excuse_nick(m, nick)
		if m.channel.users.has_key?(User(nick))
			excuse = @@excuses.sample

			m.reply "#{nick}: #{excuse}"
		else
			m.reply "I don\'t see #{nick} in this channel.", true
		end
	end
end
