#  google.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Google interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

class Google
	include Cinch::Plugin

	match /g (.+)/, method: :google_search
	match /google (.+)/, method: :google_search

	def google_search(m, search)
		url = URI.encode("https://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=large&safe=active&q=#{search}&max-results=1&v=2&prettyprint=false&alt=json")
		hash = JSON.parse(open(url).read)

		unless hash['responseData']['results'].empty?
			site = hash['responseData']['results'][0]['url']
			content = hash['responseData']['results'][0]['content'].gsub(/([\t\r\n])|(<(\/)?b>)/, '')
			content.gsub!(/(&amp;)|(&quot;)|(&lt;)|(&gt;)|(&#39;)/, '&amp;' => '&', '&quot;' => '"', '&lt;' => '<', '&gt;' => '>', '&#39;' => '\'')
			m.reply "#{m.user.nick}: #{site} - #{content}"
		else
			m.reply "#{m.user.nick}: No Google results for #{search}."
		end
	end
end
