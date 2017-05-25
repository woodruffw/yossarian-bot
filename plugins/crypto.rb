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
      coin           = normalize(coin)
      api_endpoint   = build_url(coin, currency)
      res            = JSON.parse(open(api_endpoint).read)

      if coin.nil? || res.length > 1
        m.reply "This API is not tracking \"#{coin}\" or you entered an invalid coin", true
      else
        hash = res.first
        sym, price, change, direction, currency = parse_coin_info(hash, currency)

        m.reply "1 #{sym} = #{price.to_f.round(3)} #{currency.upcase} | 1 hour change: #{direction} #{change}%", true
      end
    rescue OpenURI::HTTPError => e
      handle_error(m, e.io.status)
    rescue Exception => e
      m.reply e.to_s, true
    end
  end

  private

  def normalize(coin)
    all_coins = JSON.parse(open(BASE_URL).read)

    all_coins.each do |c|
      if c['name'] == coin || c['symbol'] == coin.upcase
        return c['name']
      end
    end

  end

  def parse_coin_info(hash, currency)
    # If we cannot find the requested currency, default to usd
    if currency.nil? || hash["price_#{currency.downcase}"].nil?
      currency = 'usd'
    end

    sym       = hash['symbol']
    price     = hash["price_#{currency}"]
    change    = hash['percent_change_1h']
    direction = (change.to_f > 0 ? "↑" : "↓")

    [sym, price, change, direction, currency]
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
      m.reply "Could not find that coin", true
    else
      m.reply "[#{code}] #{err}", true
    end
  end

end
