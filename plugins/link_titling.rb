#  link_titling.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that autotitles any links sniffed by yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'nokogiri'

require_relative 'yossarian_plugin'

class LinkTitling < YossarianPlugin
	include Cinch::Plugin

	match /(http(s)?:\/\/[^ \t]*)/, use_prefix: false, method: :link_title

	def link_title(m, link)
		html = Nokogiri::HTML(open(link))
		m.reply "Title: \"#{html.css('title').text.gsub(/[\t\r\n]/, '')}\""
	end
end
