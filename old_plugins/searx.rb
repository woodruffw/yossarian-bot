#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  searx.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Searx interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "json"
require "open-uri"

require_relative "yossarian_plugin"

class Searx < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://searx.me/?q=%{query}&format=json"

  def usage
    "!s <search> - Search Searx."
  end

  def match?(cmd)
    cmd =~ /^(!)?s$/
  end

  match /s (.+)/, method: :searx_search, strip_colors: true

  def searx_search(m, search)
    query = URI.encode(search)
    url = URL % { query: query }

    begin
      hash = JSON.parse(open(url).read)
      result = hash["results"].first

      if result
        site = result["url"]
        content = result["content"]

        m.reply "#{site} - #{content}"
      else
        m.reply "No Searx results for '#{search}'.", true
      end
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
