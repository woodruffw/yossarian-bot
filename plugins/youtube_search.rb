# frozen_string_literal: true

#  youtube_search.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides YouTube interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "addressable/uri"
require "json"
require "open-uri"

require_relative "yossarian_plugin"

class YouTubeSearch < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&q=%{query}&key=%{key}"

  def usage
    "!yt <search> - Search YouTube. Alias: !youtube."
  end

  def match?(cmd)
    cmd =~ /^(!)?(youtube)|(yt)$/
  end

  match /yt (.+)/, method: :youtube_search, strip_colors: true
  match /youtube (.+)/, method: :youtube_search, strip_colors: true

  def youtube_search(m, search)
    query = Addressable::URI.encode_component(search)
    url = URL % { query: query, key: ENV["YOUTUBE_API_KEY"] }

    begin
      hash = JSON.parse(URI.open(url).read)
      hash.default = "?"

      if hash["items"].nonempty?
        entry = hash["items"].first
        title = entry["snippet"]["title"]
        uploader = entry["snippet"]["channelTitle"]
        video_id = entry["id"]["videoId"]

        m.reply "#{title} [#{uploader}] - https://youtu.be/#{video_id}", true
      else
        m.reply "No results for #{search}.", true
      end
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
