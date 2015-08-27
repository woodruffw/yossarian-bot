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
	use_blacklist

	URL = 'http://isitup.org/%{domain}.json'

	def usage
		'!isitup <site> - Check whether or not <site> is currently online. Alias: !up.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(?:isit)?up$/
	end

	match /(?:isit)?up (.+)/, method: :isitup, strip_colors: true

	def isitup(m, site)
		domain = URI.encode(site.gsub(/^http(?:s)?:\/\//, ''))
		url = URL % { domain: domain }

		begin
			hash = JSON.parse(open(url).read)

			response_code = hash['response_code']

			case hash['status_code']
			when 1
				m.reply "#{domain} is currently online [#{response_code}].", true
			when 2
				m.reply "#{domain} is currently offline.", true
			when 3
				m.reply "#{domain} is not a valid domain.", true
			end
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
