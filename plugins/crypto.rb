# frozen_string_literal: true

require "open-uri"
require "json"

require_relative "yossarian_plugin"

class Crypto < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  BASE_URL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"

  def usage
    "!crypto <coin> [currency] - Get the current price of a coin (converted to an optional currency)"
  end

  def match?(cmd)
    cmd =~ /^(!)?crypto\s(\w+)\s?(\w+)?$/
  end

  match /crypto (.+)/, method: :crypto, strip_colors: true

  def crypto(m, payload)
    coin_name, currency = payload.split(" ").map(&:upcase)
    currency ||= "USD"
    api_endpoint = "#{BASE_URL}?symbol=#{coin_name}&convert=#{currency}"

    response = JSON.parse(open(
        api_endpoint,
        "X-CMC_PRO_API_KEY" => ENV['COINMARKETCAP_API_KEY']
      ).read)

    coin = parse_coin_info(response, coin_name, currency)

    m.reply "1 #{coin[:sym]} (#{coin[:name]}) = #{coin[:price].to_f.round(3)} #{coin[:currency].upcase} | #{fmt_changes(coin[:changes])}", true

  rescue OpenURI::HTTPError => e
    handle_error(m, e.io)
  rescue Exception => e
    m.reply e.to_s, true
  end

  private

  def fmt_changes(changes)
    changes.map do |k,v|
      direction = v.to_f > 0 ? "↑" : "↓"
      "#{k.to_s.capitalize} #{direction} #{v}%"
    end.join(" | ")
  end

  def parse_coin_info(response, coin_name, currency)
    hash = response["data"][coin_name]

    {
      name: hash["name"],
      sym: hash["symbol"],
      price: hash["quote"][currency]["price"],
      changes: {
        hourly: hash["quote"][currency]["percent_change_1h"],
        daily: hash["quote"][currency]["percent_change_24h"],
        weekly: hash["quote"][currency]["percent_change_7d"],
      },
      currency: currency,
    }
  end

  def handle_error(m, status)
    hash = JSON.parse(status.string)["status"]
    code = hash["error_code"].to_i
    err  = hash["error_message"]

    m.reply "[#{code}] #{err}", true
  end

end
