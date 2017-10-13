#  -*- coding: utf-8 -*-
#  web_search.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides search engine interaction for yossarian-bot.
#  Faroo is provided as a default search engine (http://faroo.com).
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "json"
require "open-uri"
require "sanitize"

require_relative "yossarian_plugin"

class WebSearch < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "http://www.faroo.com/instant.json?q=%{query}&start=1&l=en&src=web&i=false&c=true"

  def usage
    "!s <search> - Search the web."
  end

  def match?(cmd)
    cmd =~ /^(!)?s$/
  end

  match /s (.+)/, method: :faroo_search, strip_colors: true

  def faroo_search(m, search)
    query = URI.encode(search)
    url = URL % { query: query }

    begin
      hash = JSON.parse(open(url, "Referer" => "http://faroo.com").read)
      result = hash["results"].first

      if result
        site = result["url"]
        content = Sanitize.clean(result["content"]).normalize_whitespace

        m.reply "#{site} - #{content}"
      else
        m.reply "No results for '#{search}'.", true
      end
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
