require 'json'
require 'open-uri'

class Google
	include Cinch::Plugin

	match /g (.+)/, method: :google
	match /google (.+)/, method: :google

	def google(m, search)
		url = URI.encode("https://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=large&safe=active&q=#{search}")
		hash = JSON.parse(open(url).string)

		unless hash['responseData']['results'].empty?
			site = hash['responseData']['results'][0]['url']
			content = hash['responseData']['results'][0]['content'].gsub(/([\t\r\n])|(<(\/)?b>)/, '')
			content.gsub!(/(&amp;)|(&quot;)|(&lt;)|(&gt;)|(&#39;)/, '&amp;' => '&', '&quot;' => '"', '&lt;' => '<', '&gt;' => '>', '&#39;' => '\'')
			m.reply "#{site} - #{content}"
		else
			m.reply "No Google results for #{search}."
		end
	end
end
