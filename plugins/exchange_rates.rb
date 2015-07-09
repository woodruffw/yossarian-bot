#  -*- coding: utf-8 -*-
#  exchange_rates.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides USD currency exchange rates for yossarian-bot.
#  Data courtesy of Open Exchange Rates: https://openexchangerates.org/
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class ExchangeRates < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@key = ENV['OEX_API_KEY']
	end

	def usage
		'!rate <code [code2...]> - Get the currency exchange rate between USD and one or more currencies.'
	end

	def match?(cmd)
		cmd =~ /^(!)?rate$/
	end

	match /rate (.+)/, method: :exchange_rate, strip_colors: true

	def exchange_rate(m, code)
		if @key
			codes = code.upcase.split
			url = "https://openexchangerates.org/api/latest.json?app_id=#{@key}"

			begin
				hash = JSON.parse(open(url).read)
				hash.default = '?'

				rates = codes.map do |curr|
					"USD/#{curr}: #{hash['rates'][curr]}"
				end.join(', ')

				m.reply rates, true
			rescue Exception => e
				m.reply e.to_s, true
			end
		else
			m.reply 'Internal error (missing API key).'
		end
	end
end
