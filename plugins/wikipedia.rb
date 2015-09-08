#  -*- coding: utf-8 -*-
#  wikipedia.rb
#  Authors: slackR (slackErEhth77) and William Woodruff
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
	use_blacklist

	URL = "https://en.wikipedia.org/w/api.php?action=opensearch&format=json&search=%{query}"

	def usage
		'!wiki <search> - Search Wikipedia for the given <search>.'
	end

	def match?(cmd)
		cmd =~ /^(!)?wiki$/
	end

	match /wiki (.+)/, method: :search_wiki, strip_colors: true

	def search_wiki(m, search)
		query = URI.encode(search)
		url = URL % { query: query }

		begin
			results = JSON.parse(open(url).read)
			if !results[1].empty?
				if results[2].first.empty?
					content = "No extract provided."
				else
					content = results[2].first
				end
				link = results[3].first.sub('https://en.wikipedia.org/wiki/', 'http://enwp.org/')

				m.reply "#{link} - #{content}", true
			else
				m.reply "No results for #{search}.", true
			end
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
