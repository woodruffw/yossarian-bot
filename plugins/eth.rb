#  -*- coding: utf-8 -*-
#  eth.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves Ethereum exchange rates for yossarian-bot.
#  Data courtesy of https://coinmarketcap-nexuist.rhcloud.com/api/eth
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'open-uri'
require 'json'

require_relative 'yossarian_plugin'

class ETH < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = 'https://coinmarketcap-nexuist.rhcloud.com/api/eth'

  def initialize(*args)
    super
    @last_trade = nil
  end

  def usage
    '!eth - Get the current Ethereum exchange rate in USD.'
  end

  def match?(cmd)
    cmd =~ /^(!)?eth$/
  end

  match /eth$/, method: :eth_rate

  def eth_rate(m)
    begin
      hash   = JSON.parse(open(URL).read)
      rate   = hash["price"]["usd"].round(2)
      change = hash["change"].to_f

      if @last_trade.nil?
        m.reply "1 ETH = #{rate} USD", true
      else
        direction = (change > 0 ? "↑" : "↓")
        m.reply "1 ETH = #{rate} USD | #{direction}", true
      end

      @last_trade = rate

    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
