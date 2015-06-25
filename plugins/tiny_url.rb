#  -*- coding: utf-8 -*-
#  tiny_url.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides TinyURL interaction to yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'open-uri'

require_relative 'yossarian_plugin'

class TinyURL < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def usage
		'!turl <url> - Shorten the given <url> using TinyURL. Alias: !tinyurl.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(tinyurl)|(turl)$/
	end

	match /turl (#{URI::regexp(['http', 'https'])})/, method: :tinyurl, strip_colors: true
	match /tinyurl (#{URI::regexp(['http', 'https'])})/, method: :tinyurl, strip_colors: true

	def tinyurl(m, link)
		url = "http://tinyurl.com/api-create.php?url=#{URI.encode(link)}"
		begin
			short_link = open(url).read
			m.reply short_link, true
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
