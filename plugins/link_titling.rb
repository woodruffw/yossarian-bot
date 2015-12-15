#  -*- coding: utf-8 -*-
#  link_titling.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that autotitles any links sniffed by yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'uri'
require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'

require_relative 'yossarian_plugin'

class LinkTitling < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	match /(#{URI::regexp(['http', 'https'])})/, use_prefix: false, method: :link_title

	def link_title(m, link)
		begin
			html = Nokogiri::HTML(open(link, {:read_timeout => 3, :allow_redirections => :safe}))
			title = html.css('title').text.gsub(/[ \t\r\n]+/, ' ').strip

			if !title.empty?
				m.reply "Title: \'#{title}\'"
			end
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
