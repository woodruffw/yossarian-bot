#  -*- coding: utf-8 -*-
#  luther_insults.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that grabs Insults by Martin Luther for yossarian-bot.
#  luther_insults.txt from http://ergofabulous.org/luther/insult-list.php
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'nokogiri'
require 'open-uri'

require_relative '../yossarian_plugin'

class LutherInsults < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	INSULTS_FILE = File.expand_path(File.join(File.dirname(__FILE__), 'luther_insults.txt'))
	INSULTS = File.readlines(INSULTS_FILE)

	def usage
		'!luther [nick] - Fetch a random insult from Martin Luther\'s oeuvre and direct it at a nickname if given.'
	end

	def match?(cmd)
		cmd =~ /^(!)?luther$/
	end

	match /luther$/, method: :luther_insult

	def luther_insult(m)
		m.reply INSULTS.sample, true
	end

	match /luther (\S+)/, method: :luther_insult_nick, strip_colors: true

	def luther_insult_nick(m, nick)
		if m.channel.has_user?(nick)
			insult = INSULTS.sample
			m.reply "#{nick}: #{insult}"
		else
			m.reply "I don\'t see #{nick} in this channel."
		end
	end
end
