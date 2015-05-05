#  -*- coding: utf-8 -*-
#  wikipedia.rb
#  Author: slackR | slackErEhth77
#  ------------------------
#  A Cinch plugin to get info from Wikipedia for yossarian-bot.
#  ------------------------
#  This code is licensed by slackErEhth77 under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class Wikipedia < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!wiki <search> - Search Wikipedia for the given <search>.'
	end

	def match?(cmd)
		cmd =~ /^(!)?wiki$/
	end

	match /wiki (.+)/, method: :search_wiki

	def search_wiki(m, search)
		query = URI.encode(search.titleize)
		url = "https://en.wikipedia.org/w/api.php?action=opensearch&format=json&search=#{query}"
		array = JSON.parse(open(url).read)

        if array[1].empty?
			m.reply "Sorry no result for #{query}", true

		else

			content = array[2].first
		    link = array[3].first.sub('https://en.wikipedia.org/wiki/', 'http://enwp.org/')
			m.reply "#{link} - #{content}", true

		end
	end
end
