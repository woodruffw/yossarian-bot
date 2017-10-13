#  -*- coding: utf-8 -*-
#  fieri_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Guy Fieri quotes for yossarian-bot.
#  fieri_quotes.txt compiled from various sources.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "../yossarian_plugin"

class FieriQuotes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  QUOTES_FILE = File.expand_path(File.join(File.dirname(__FILE__), "fieri_quotes.txt"))
  QUOTES = File.readlines(QUOTES_FILE)

  def usage
    "!fieri - Fetch a random Guy Fieri quote."
  end

  def match?(cmd)
    cmd =~ /^(!)?fieri$/
  end

  match /fieri$/, method: :theo_quote

  def theo_quote(m)
    m.reply QUOTES.sample
  end
end
