require 'json'

class UrbanDictionary
	include Cinch::Plugin

	match /ud (.+)/, method: :urban_dict
	match /urban (.+)/, method: :urban_dict

	def urban_dict(m, query)
		query = URI.encode(query)
		data = Net::HTTP.get(URI("http://api.urbandictionary.com/v0/define?term=#{query}"))
		hash = JSON.parse(data)
		if hash['list'].empty?
			m.reply "No definition for #{query}."
		else
			list = hash['list'][0]
			m.reply "#{m.user.nick}: #{query} - #{list['definition'][0..255].gsub(/[\r\n]/, '')}... (#{list['permalink']})"
		end
	end
end
