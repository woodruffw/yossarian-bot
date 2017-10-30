# frozen_string_literal: true

#  google_search.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Google interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "json"
require "open-uri"

require_relative "yossarian_plugin"

class GoogleSearch < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=small&safe=active&q=%{query}&max-results=1&v=2&alt=json"

  def usage
    "!g <search> - Search Google. Alias: !google."
  end

  def match?(cmd)
    cmd =~ /^(!)?g(?:oogle)?$/
  end

  match /g(?:oogle)? (.+)/, method: :google_search, strip_colors: true

  def google_search(m, search)
    query = URI.encode(search)
    url = URL % { query: query }

    begin
      hash = JSON.parse(open(url).read)

      if hash["responseData"]["results"].nonempty?
        site = URI.unescape(hash["responseData"]["results"].first["url"])
        content = hash["responseData"]["results"].first["content"].gsub(/([\t\r\n])|(<(\/)?b>)/, "")
        content.gsub!(/(&amp;)|(&quot;)|(&lt;)|(&gt;)|(&#39;)/, "&amp;" => "&", "&quot;" => '"', "&lt;" => "<", "&gt;" => ">", "&#39;" => "'")
        m.reply "#{site} - #{content}", true
      else
        m.reply "No Google results for #{search}.", true
      end
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
