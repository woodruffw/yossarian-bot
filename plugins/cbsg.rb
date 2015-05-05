#  -*- coding: utf-8 -*-
#  cbsg.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that grabs generated corporate bullshit for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'nokogiri'
require 'open-uri'

require_relative 'yossarian_plugin'

class CBSG < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@url = 'http://cbsg.sourceforge.net/cgi-bin/live'
	end

	def usage
		'!cbsg - Spew some corporate bullshit.'
	end

	def match?(cmd)
		cmd =~ /^(!)?cbsg$/
	end

	match /cbsg$/, method: :cbsg

	def cbsg(m)
		begin
			page = Nokogiri::HTML(open(@url).read)

			m.reply page.css('li')[0].text, true
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
