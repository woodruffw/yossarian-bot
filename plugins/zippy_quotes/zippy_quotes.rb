# frozen_string_literal: true

#  zippy_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Zippy the Pinhead quotes for yossarian-bot.
#  zippy_quotes.txt is converted from the original (?) MIT "yow.lines".
#  ------------------------
#  This code is licensed by Winston Weinert under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "../yossarian_plugin"

class ZippyQuotes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  QUOTES_FILE = File.expand_path(File.join(File.dirname(__FILE__), "zippy_quotes.txt"))
  QUOTES = File.readlines(QUOTES_FILE)

  def usage
    "!zippy - Fetch a random Zippy the Pinhead quote. Aliases: !pinhead."
  end

  def match?(cmd)
    cmd =~ /^(!)?(zippy|pinhead)$/
  end

  match /(zippy|pinhead)$/, method: :zippy_quote

  def zippy_quote(m)
    m.reply QUOTES.sample
  end
end

