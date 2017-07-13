#  -*- coding: utf-8 -*-
#  giphy.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves GIFs from Giphy for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class Giphy < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV['GIPHY_API_KEY']
  URL = 'http://api.giphy.com/v1/gifs/search?q=%{query}&api_key=%{key}&limit=100'

  def usage
    '!giphy <search> - Search Giphy for GIFs. Alias: !gif.'
  end

  def match?(cmd)
    cmd =~ /^(!)?gi(?:phy|f)$/
  end

  match /gi(?:phy|f) (.+)$/, method: :giphy, strip_colors: true

  def giphy(m, search)
    if KEY
      query = URI.encode(search)
      url = URL % { query: query, key: KEY }

      begin
        hash = JSON.parse(open(url).read)

        if hash['data'].nonempty?
          gif = hash['data'].sample['images']['original']

          gif_url = gif['url']
          gif_dim = "#{gif['width']}x#{gif['height']}"

          m.reply "#{gif_url} (#{gif_dim})", true
        else
          m.reply "No Giphy results for #{search}.", true
        end
      rescue Exception => e
        m.reply e.to_s, true
      end
    else
      m.reply "#{self.class.name}: Internal error (missing API key)."
    end
  end
end
