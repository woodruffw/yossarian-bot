#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  link_titling.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that autotitles any links sniffed by yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "uri"
require "open-uri"
require "open_uri_redirections"
require "nokogiri"
require "timeout"

require_relative "yossarian_plugin"

class LinkTitling < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  YOUTUBE_KEY = ENV["YOUTUBE_API_KEY"]
  YOUTUBE_URL = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics,contentDetails&id=%{id}&key=%{key}"

  match /(#{URI::regexp(['http', 'https'])})/, use_prefix: false, method: :link_title

  def link_title(m, link)
    uri = URI(link)

    case uri.host
    when /youtube.com/, /youtu.be/
      title = youtube_title(uri)
    else
      title = generic_title(uri)
    end

    if title && !title.empty?
      m.reply "Title: #{title}"
    end
  end

  def generic_title(uri)
    begin
      Timeout::timeout(5) do
        html = Nokogiri::HTML(open(uri, { :allow_redirections => :safe }))
        html.css("title").text.normalize_whitespace
      end
    rescue Exception
      "Unknown"
    end
  end

  def youtube_title(uri)
    query = uri.query || ""
    id = URI::decode_www_form(query).to_h["v"]

    if id.nil?
      generic_title(uri)
    else
      api_url = YOUTUBE_URL % { id: id, key: YOUTUBE_KEY }

      begin
        hash = JSON.parse(open(api_url).read)["items"].first
        hash["snippet"]["title"]
      rescue Exception => e
        "Unknown"
      end
    end
  end
end
