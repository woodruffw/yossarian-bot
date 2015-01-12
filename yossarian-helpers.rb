#  yossarian-helpers.rb
#  Author: William Woodruff
#  ------------------------
#  Methods used by yossarian-bot for various commands.

require 'uri'
require 'open-uri'
require 'json'
require 'nokogiri'

def rot13(msg)
	return msg.tr("A-Ma-mN-Zn-z", "N-Zn-zA-Ma-m")
end

def link_title(link)
	html = Nokogiri::HTML(open(link))
	return html.css('title').text.gsub(/[\t\r\n]/, '')
end
