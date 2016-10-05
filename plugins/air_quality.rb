#  -*- coding: utf-8 -*-
#  bot_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves air quality info for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class AirQuality < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	KEY = ENV['AIRNOW_API_KEY']
	URL = 'https://www.airnowapi.org/aq/forecast/zipCode/?' \
		'format=application/json&' \
		'zipCode=%{zip}&' \
		'API_KEY=%{key}'

	def usage
		'!aq <zip> - Retrieve the air quality index for the given zip code.'
	end

	def match?(cmd)
		cmd =~ /^(!)?aq$/
	end

	match /aq (\d{5})/, method: :air_quality

	def air_quality(m, zip)
		if KEY
			url = URL % { key: KEY, zip: zip }

			begin
				hash = JSON.parse(open(url).read).first

				if hash
					region = hash['ReportingArea']
					category = hash['Category']['Name']
					param = hash['ParameterName']
					aqi = hash['AQI']

					m.reply "#{region} is #{category} with an AQI of #{aqi} (#{param}).", true
				else
					m.reply "#{zip} is not a valid ZIP code.", true
				end
			rescue Exception => e
				m.reply e.to_s
			end
		else
			m.reply "#{self.class.name}: Internal error (missing API key)."
		end
	end
end
