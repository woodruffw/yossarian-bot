# frozen_string_literal: true

#  linus_quotes.rb
#  Author: Winston Weinert
#  ------------------------
#  A Cinch plugin that provides Linus Torvalds quotes for yossarian-bot.
#  linus_quotes.txt generated from Wikiquote's article
#  ------------------------
#  This code is licensed by Winston Weinert under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "../yossarian_plugin"

class LinusQuotes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  QUOTES_FILE = File.expand_path(File.join(File.dirname(__FILE__), "linus_quotes.txt"))
  QUOTES = File.readlines(QUOTES_FILE)

  def usage
    "!linus - Fetch a random Linus Torvalds quote. Aliases: !torvalds."
  end

  def match?(cmd)
    cmd =~ /^(!)?(linus|torvalds)$/
  end

  match /(linus|torvalds)$/, method: :linus_quote

  def linus_quote(m)
    m.reply QUOTES.sample
  end
end
