#  -*- coding: utf-8 -*-
#  theo_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Theo De Raadt quotes for yossarian-bot.
#  theo_quotes.txt generated from Plan9Front's `theo`.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "../yossarian_plugin"

class TheoQuotes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  QUOTES_FILE = File.expand_path(File.join(File.dirname(__FILE__), "theo_quotes.txt"))
  QUOTES = File.readlines(QUOTES_FILE)

  def usage
    "!theo - Fetch a random Theo De Raadt quote."
  end

  def match?(cmd)
    cmd =~ /^(!)?theo$/
  end

  match /theo$/, method: :theo_quote

  def theo_quote(m)
    m.reply QUOTES.sample
  end
end
