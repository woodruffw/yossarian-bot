#  -*- coding: utf-8 -*-
#  btc.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves Bitcoin exchange rates for yossarian-bot.
#  Data courtesy of the BitcoinAverage Price Index: https://bitcoinaverage.com/
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'open-uri'

require_relative 'yossarian_plugin'

class BTC < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@url = 'https://api.bitcoinaverage.com/ticker/global/USD/last'
	end

	def usage
		'!btc - Get the current Bitcoin exchange rate in USD.'
	end

	def match?(cmd)
		cmd =~ /^(!)?btc$/
	end

	match /btc$/, method: :btc_rate

	def btc_rate(m)
		begin
			rate = open(@url).read
			m.reply "1 BTC = #{rate} USD", true
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
