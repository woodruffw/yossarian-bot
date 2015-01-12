#  youtube.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides YouTube interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

class YouTube
	include Cinch::Plugin

	match /yt (.+)/, method: :youtube_search
	match /youtube (.+)/, method: :youtube_search

	def youtube_search(m, search)
		url = URI.encode("http://gdata.youtube.com/feeds/api/videos?q=#{search}&max-results=1&v=2&prettyprint=flase&alt=json")
		hash = JSON.parse(open(url).read)

		if hash['feed']['openSearch$totalResults'] != 0
			entry = hash['feed']['entry'][0]
			title = entry['title']['$t']
			uploader = entry['author'][0]['name']['$t']
			video_id = entry['media$group']['yt$videoid']['$t']

			m.reply "#{m.user.nick}: #{title} [#{uploader}] - https://youtu.be/#{video_id}"
		else
			m.reply "#{m.user.nick}: No results for #{search}."
		end
	end
end