# frozen_string_literal: true

#  rms_quotes.rb
#  Author: Winston Weinert
#  ------------------------
#  A Cinch plugin that provides Richard Stallman (rms) quotes for yossarian-bot.
#  rms_quotes.txt is parsed from https://github.com/faiq/rms
#  ------------------------
#  This code is licensed by Winston Weinert under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "../yossarian_plugin"

class RMSQuotes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  QUOTES_FILE = File.expand_path(File.join(File.dirname(__FILE__), "rms_quotes.txt"))
  QUOTES = File.readlines(QUOTES_FILE)

  def usage
    "!rms - Fetch a random Richard Stallman quote. Aliases: !stallman."
  end

  def match?(cmd)
    cmd =~ /^(!)?(rms|stallman)$/
  end

  match /(rms|stallman)$/, method: :rms_quote

  def rms_quote(m)
    m.reply QUOTES.sample
  end
end
