#  -*- coding: utf-8 -*-
#  isitup.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides IsItUp.org functionality for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class IsItUp < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!isitup <site> - Check whether or not <site> is currently online. Alias: !up.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(?:isit)?up$/
	end

	match /(?:isit)?up (.+)/, method: :isitup, strip_colors: true

	def isitup(m, site)
		url = "http://isitup.org/#{URI.encode(site)}.json"
		hash = JSON.parse(open(url).read)

		domain = hash['domain']
		response_code = hash['response_code']

		case hash['status_code']
		when 1
			m.reply "#{m.user.nick}: #{domain} is currently online [#{response_code}]."
		when 2
			m.reply "#{m.user.nick}: #{domain} is currently offline."
		when 3
			m.reply "#{m.user.nick}: #{domain} is not a valid URL."
		end
	end
end
