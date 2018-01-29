# frozen_string_literal: true

#  cbsg.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that grabs generated corporate bullshit for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "nokogiri"
require "open-uri"

require_relative "yossarian_plugin"

class CBSG < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "http://cbsg.sourceforge.io/cgi-bin/live"

  def usage
    "!cbsg - Spew some corporate bullshit."
  end

  def match?(cmd)
    cmd =~ /^(!)?cbsg$/
  end

  match /cbsg$/, method: :cbsg

  def cbsg(m)
    page = Nokogiri::HTML(open(URL).read)

    m.reply page.css("li").first.text, true
  rescue Exception => e
    m.reply e.to_s, true
  end
end
