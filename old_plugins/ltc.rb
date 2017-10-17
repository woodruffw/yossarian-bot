#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  ltc.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves Litecoin exchange rates for yossarian-bot.
#  Data courtesy of the BTC-e exchange: https://btc-e.com
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "open-uri"
require "json"

require_relative "yossarian_plugin"

class LTC < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://btc-e.com/api/3/ticker/ltc_usd"

  def initialize(*args)
    super
    @last_trade = nil
  end

  def usage
    "!ltc - Get the current Litecoin exchange rate in USD."
  end

  def match?(cmd)
    cmd =~ /^(!)?ltc$/
  end

  match /ltc$/, method: :ltc_rate

  def ltc_rate(m)
    hash = JSON.parse(open(URL).read)
    rate = hash["ltc_usd"]["buy"].round(2)

    if @last_trade.nil?
      m.reply "1 LTC = #{rate} USD", true
    else
      direction = (@last_trade < rate ? "↑" : "↓")
      m.reply "1 LTC = #{rate} USD | #{direction}", true
    end

    @last_trade = rate

  rescue Exception => e
    m.reply e.to_s, true
  end
end
