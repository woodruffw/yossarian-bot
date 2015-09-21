#  -*- coding: utf-8 -*-
#  urban_dictionary.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides UrbanDictionary interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class UrbanDictionary < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	URL = 'http://api.urbandictionary.com/v0/define?term=%{query}'

	def usage
		'!ud <phrase> - Look up <phrase> on UrbanDictionary. Alias: !urban.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(ud)|(urban)$/
	end

	match /ud (.+)/, method: :urban_dict, strip_colors: true
	match /urban (.+)/, method: :urban_dict, strip_colors: true

	def urban_dict(m, phrase)
		query = URI.encode(phrase)
		url = URL % { query: query }

		begin
			hash = JSON.parse(open(url).read)

			if hash['list'].nonempty?
				list = hash['list'].first
				definition = list['definition'][0..255].gsub(/[\r\n]/, '')
				link = list['permalink']
				m.reply "#{phrase} - #{definition}... (#{link})", true
			else
				m.reply "UrbanDictionary has nothing for #{phrase}."
			end
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
