#  -*- coding: utf-8 -*-
#  lennart_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Lennart Poettering quotes for yossarian-bot.
#  lennart_quotes.txt graciously collected by "rewt".
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "../yossarian_plugin"

class LennartQuotes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  QUOTES_FILE = File.expand_path(File.join(File.dirname(__FILE__), "lennart_quotes.txt"))
  QUOTES = File.readlines(QUOTES_FILE)

  def usage
    "!lennart - Fetch a random Lennart Poettering quote."
  end

  def match?(cmd)
    cmd =~ /^(!)?lennart$/
  end

  match /lennart$/, method: :lennart_quote

  def lennart_quote(m)
    m.reply QUOTES.sample
  end
end
