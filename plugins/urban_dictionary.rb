#  urban_dictionary.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides UrbanDictionary interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'

require_relative 'yossarian_plugin'

class UrbanDictionary < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!ud <query> - Look up <query> on UrbanDictionary. Alias: !urban.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(ud)|(urban)$/
	end

	match /ud (.+)/, method: :urban_dict, strip_colors: true
	match /urban (.+)/, method: :urban_dict, strip_colors: true

	def urban_dict(m, query)
		data = Net::HTTP.get(URI("http://api.urbandictionary.com/v0/define?term=#{URI.encode(query)}"))
		hash = JSON.parse(data)
		if hash['list'].empty?
			m.reply "UrbanDictionary has nothing for #{query}."
		else
			list = hash['list'][0]
			definition = list['definition'][0..255].gsub(/[\r\n]/, '')
			link = list['permalink']
			m.reply "#{m.user.nick}: #{query} - #{definition}... (#{link})"
		end
	end
end
