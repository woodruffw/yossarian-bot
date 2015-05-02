#  -*- coding: utf-8 -*-
#  wikipedia.rb
#  Author: slackR | slackErEhth77
#  ------------------------
#  A Cinch plugin to get info from Wikipedia for yossarian-bot.
#  ------------------------
#  This code is licensed by slackErEhth77 under the MIT License.
#  http://opensource.org/licenses/MIT

require 'sanitize'
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
		query = URI.encode(search)
		url = "http://en.wikipedia.org/w/api.php?action=query&prop=extracts&titles=#{query}&format=json&exintro=1"
		hash = JSON.parse(open(url).read)

			if hash['query']['pages']['-1']
				m.reply "No results for #{search}."
			else
				page_id = hash['query']['pages'].keys.pop()
				content = Sanitize.clean(hash['query']['pages'][page_id]['extract']).gsub(/[\t\r\n]/, '')
				m.reply "http://enwp.org/#{query} - #{content}", true
			end
	end
end
