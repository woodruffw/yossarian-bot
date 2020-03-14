# frozen_string_literal: true

#  stock_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Yahoo! Finanance stock quotes for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "open-uri"
require "json"

require_relative "yossarian_plugin"

class StockQuotes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=%{ticker}&apikey=%{api_key}"

  def usage
    "!stock <symbol> - Retrieve a stock quote for the given ticker symbol."
  end

  def match?(cmd)
    cmd =~ /^(!)?stock$/
  end

  match /stock (\w+)$/, method: :stock_quote, strip_colors: true

  def stock_quote(m, symbol)
    symbol = URI.encode(symbol)
    url = URL % { ticker: symbol, api_key: ENV["ALPHA_VANTAGE_API_KEY"] }

    begin
      res = JSON.parse(open(url).read)

      if res["Error Message"]
        m.reply res["Error Message"], true
      else
        # Format the absolutely horrible API response
        res     = res.values.first.transform_keys! { |k| k.split(" ").last }
        tick    = res["symbol"]
        price   = res["price"].to_f
        percent = res["percent"]

        m.reply "#{tick} - Trading at $#{price} (#{percent})", true
      end
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
