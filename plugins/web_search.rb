# frozen_string_literal: true

#  web_search.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides search engine interaction for yossarian-bot.
#  Google is used as the default engine.
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

  URL = "https://www.googleapis.com/customsearch/v1?key=%<key>s&cx=%<cx>s&q=%<query>s"
  KEY = ENV["GOOGLE_SEARCH_API_KEY"]
  ENGINE_ID = ENV["GOOGLE_SEARCH_ENGINE_ID"]

  def usage
    "!g <search> - Search the web with Google."
  end

  def match?(cmd)
    cmd =~ /^(!)?g$/
  end

  match /g (.+)/, method: :google_search, strip_colors: true

  def google_search(m, search)
    unless KEY && ENGINE_ID
      m.reply "#{self.class.name}: Internal error (missing API keys)."
      return
    end

    query = URI.encode(search)
    url = URL % { key: KEY, cx: ENGINE_ID, query: query }

    begin
      hsh = JSON.parse(open(url).read)

      result = hsh["items"].first

      if result
        site = result["link"]
        content = Sanitize.clean(result["snippet"]).normalize_whitespace

        m.reply "#{site} - #{content}", true
      else
        m.reply "No Google results for '#{search}'.", true
      end
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
