#  -*- coding: utf-8 -*-
#  luther_insults.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that grabs Insults by Martin Luther for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'nokogiri'
require 'open-uri'

require_relative 'yossarian_plugin'

class LutherInsults < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@url = 'http://ergofabulous.org/luther/'
	end

	def usage
		'!luther [nick] - Fetch a random insult from Martin Luther\'s oeuvre and direct it at a nickname if given.'
	end

	def match?(cmd)
		cmd =~ /^(!)?luther$/
	end

	match /luther$/, method: :luther_insult

	def luther_insult(m)
		page = Nokogiri::HTML(open(@url).read)
		insult = page.css('p')[0].text

		m.reply insult, true
	end

	match /luther (\S+)/, method: :luther_insult_nick

	def luther_insult_nick(m, nick)
		if m.channel.users.has_key?(User(nick))
			begin
				page = Nokogiri::HTML(open(@url).read)
				insult = page.css('p')[0].text

				m.reply "#{nick}: #{insult}"
			rescue Exception => e
				m.reply e.to_s, true
			end
		else
			m.reply "I don\'t see #{nick} in this channel."
		end
	end
end
