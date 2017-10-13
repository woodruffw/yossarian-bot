# frozen_string_literal: true

require "open-uri"
require "json"

require_relative "yossarian_plugin"

class Crypto < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  BASE_URL = "https://api.coinmarketcap.com/v1/ticker/"

  def usage
    "!crypto <coin> [currency] - Get the current price of a coin (converted to an optional currency)"
  end

  def match?(cmd)
    cmd =~ /^(!)?crypto\s(\w+)\s?(\w+)?$/
  end

  match /crypto (.+)/, method: :crypto, strip_colors: true

  def crypto(m, payload)
    begin
      coin_name, currency = payload.split(" ")
      api_endpoint        = build_url(currency)
      res                 = JSON.parse(open(api_endpoint).read)

      coin = parse_coin_info(res, coin_name, currency)

      m.reply "1 #{coin[:sym]} (#{coin[:name]}) = #{coin[:price].to_f.round(3)} #{coin[:currency].upcase} | #{fmt_changes(coin[:changes])}", true

    rescue OpenURI::HTTPError => e
      handle_error(m, e.io.status)
    rescue Exception => e
      m.reply e.to_s, true
    end
  end

  private

  def find_matching_coin(res, coin_name)
    res.each do |c|
      if c["name"].downcase == coin_name || c["symbol"] == coin_name.upcase
        return c
      end
    end

    raise "No matching coin found for #{coin_name}"
  end

  def fmt_changes(changes)
    changes.map do |k,v|
      direction = v.to_f > 0 ? "↑" : "↓"
      "#{k.to_s.capitalize} #{direction} #{v}%"
    end.join(" | ")
  end

  def parse_coin_info(res, coin_name, currency)
    hash = find_matching_coin(res, coin_name)

    # If we cannot find the requested currency, default to usd
    if currency.nil? || hash["price_#{currency.downcase}"].nil?
      currency = "usd"
    end

    {
      name: hash["name"],
      sym: hash["symbol"],
      price: hash["price_#{currency}"],
      changes: {
        hourly: hash["percent_change_1h"],
        daily: hash["percent_change_24h"],
        weekly: hash["percent_change_7d"]
      },
      currency: currency
    }
  end

  def build_url(currency)
    url = BASE_URL

    if currency
      url = url + "/?convert=" + currency
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
