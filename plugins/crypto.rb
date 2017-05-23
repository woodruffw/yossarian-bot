require 'open-uri'
require 'json'

require_relative 'yossarian_plugin'

class Crypto < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  BASE_URL = 'https://api.coinmarketcap.com/v1/ticker/'

  def usage
    '!crypto <coin> [currency] - Get the current price of a coin (converted to an optional currency)'
  end

  def match?(cmd)
    cmd =~ /^(!)?crypto\s(\w+)\s?(\w+)?$/
  end

  match /crypto (.+)/, method: :crypto, strip_colors: true

  def crypto(m, payload)
    begin
      coin, currency = payload.split(' ')
      api_endpoint   = build_url(coin, currency)
      res            = JSON.parse(open(api_endpoint).read)

      if coin.nil? || res.length > 1
        m.reply "This API is not tracking \"#{coin}\" or you entered an invalid coin", true
      else
        hash = res.first
        # If we cannot find the requested currency, default to usd
        if currency.nil? || hash["price_#{currency.downcase}"].nil?
          currency = 'usd'
        end

        sym, price, change = coin_info(hash, coin, currency)
        direction = (change.to_f > 0 ? "↑" : "↓")

        m.reply "1 #{sym} = #{price.to_f.round(3)} | 1 hour change: #{direction} #{change}%", true
      end
    rescue OpenURI::HTTPError => e
      handle_error(m, e.io.status)
    rescue Exception => e
      m.reply e.to_s, true
    end
  end

  private

  def coin_info(hash, coin, currency)
    sym    = hash['symbol']
    price  = hash["price_#{currency}"]
    change = hash['percent_change_1h']

    [sym, price, change]
  end

  def build_url(coin, currency)
    url = BASE_URL + coin

    if currency
      url = url + '/?convert=' + currency
    end

    url
  end

  def handle_error(m, status)
    code = status[0].to_i
    err  = status[1]

    if code == 404
      m.reply "Could not find that coin. Make sure you use the full name (i.e. bitcoin, ethereum, etc.)", true
    else
      m.reply "[#{code}] #{err}", true
    end
  end

end
