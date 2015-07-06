#  -*- coding: utf-8 -*-
#  ltc.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves Litecoin exchange rates for yossarian-bot.
#  Data courtesy of the BTC-e exchange: https://btc-e.com
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'open-uri'
require 'json'

require_relative 'yossarian_plugin'

class LTC < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@url = 'https://btc-e.com/api/3/ticker/ltc_usd'
	end

	def usage
		'!ltc - Get the current Litecoin exchange rate in USD.'
	end

	def match?(cmd)
		cmd =~ /^(!)?ltc$/
	end

	match /ltc$/, method: :ltc_rate

	def ltc_rate(m)
		begin
			hash = JSON.parse(open(@url).read)
			rate = hash['ltc_usd']['buy'].round(2)

			m.reply "1 LTC = #{rate} USD", true
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
