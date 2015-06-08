#  -*- coding: utf-8 -*-
#  stock_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that Yahoo! Finanance stock quotes for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'open-uri'
require 'csv'

require_relative 'yossarian_plugin'

class StockQuotes < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def usage
		'!stock <symbol> - Retrieve a stock quote for the given ticker symbol.'
	end

	def match?(cmd)
		cmd =~ /^(!)?stock$/
	end

	match /stock (\w+)$/, method: :stock_quote, strip_colors: true

	def stock_quote(m, symbol)
		query = URI.encode(symbol)
		url = "http://finance.yahoo.com/d/quotes.csv?s=#{query}&f=snl1c1"

		begin
			quote = CSV.parse(open(url).read).first
			tick, name, trade, change = quote[0..3]
			if name != 'N/A'
				m.reply "#{name} (#{tick}) - Trading at $#{trade} (#{change}%)", true
			else
				m.reply "Could not find a quote for #{tick}.", true
			end
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end
