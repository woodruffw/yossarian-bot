#  cleverbot.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Cleverbot interaction to yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'open-uri'

require_relative 'yossarian_plugin'

class TinyURL < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!turl <url> - Shorten the given <url> using TinyURL.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(tinyurl)|(turl)$/
	end

	match /turl (http(s)?:\/\/[^ \t]*)/, method: :tinyurl
	match /tinyurl (http(s)?:\/\/[^ \t]*)/, method: :tinyurl

	def tinyurl(m, link)
		url = "http://tinyurl.com/api-create.php?url=#{URI.encode(link)}"
		short_link = open(url).read
		m.reply "#{m.user.nick}: #{short_link}"
	end
end
