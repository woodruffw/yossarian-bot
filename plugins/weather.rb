#  -*- coding: utf-8 -*-
#  weather.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Weather Underground interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'wunderground'

require_relative 'yossarian_plugin'

class Weather < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!w <location> - Get the weather at <location>. Alias: !weather.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(weather)|(^w)$/
	end

	match /w (.+)/, method: :weather, strip_colors: true
	match /weather (.+)/, method: :weather, strip_colors: true

	def weather(m, location)
		if ENV.has_key?('WUNDERGROUND_API_KEY')
			wu = Wunderground.new(ENV['WUNDERGROUND_API_KEY'])
			hash = wu.conditions_for(location)

			unless hash['current_observation'] == nil
				loc = hash['current_observation']['display_location']['full']
				weather = hash['current_observation']['weather']
				temp = hash['current_observation']['temperature_string']
				m.reply "Current temperature in #{loc} is #{temp} and #{weather}.", true
			else
				m.reply "Bad weather query for #{location}.", true
			end
		else
			m.reply 'Internal error (missing API key).'
		end
	end
end
