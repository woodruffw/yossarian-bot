# frozen_string_literal: true

#  google_translate.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin for interfacing with Google Translate.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "addressable/uri"
require "json"
require "open-uri"

require_relative "yossarian_plugin"

class GoogleTranslate < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://translate.googleapis.com/translate_a/t?client=a&sl=auto&tl=en&q=%{query}"

  def usage
    "!tr <text>- Translate <text> to English. Alias: !translate."
  end

  def match?(cmd)
    cmd =~ /^(!)?tr(?:anslate)?$/
  end

  match /tr(?:anslate)? (.+)/, method: :google_translate_auto, strip_colors: true

  def google_translate_auto(m, msg)
    query = Addressable::URI.encode(msg)
    url = URL % { query: query }

    begin
      hash = JSON.parse(open(url).read)
      result = hash["sentences"].first["trans"]
      m.reply result, true
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
