#  -*- coding: utf-8 -*-
#  myanimelist.rb
#  Author: Winston Weinert
#  ------------------------
#  A Cinch plugin that provides MyAnimeList search interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by Winston Weinert under the MIT License.
#  http://opensource.org/licenses/MIT

require "htmlentities"
require "myanimelist"

require_relative "yossarian_plugin"

class MyAnimeListSearch < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def initialize(*args)
    super
    MyAnimeList.configure do |cfg|
      cfg.username = ENV["MAL_USERNAME"]
      cfg.password = ENV["MAL_PASSWORD"]
    end
    @entities = HTMLEntities.new
  end

  def usage
    "!<anime|manga> <search> - Search MyAnimeList for anime or manga."
  end

  def match?(cmd)
    cmd =~ /^(!)?(anime|manga)$/
  end

  match /(anime|manga) (.+)/, method: :search, strip_colors: true

  def search(m, type, query)
    begin
      res = type == "anime" ? MyAnimeList.search_anime(query) : MyAnimeList.search_manga(query)
    rescue MyAnimeList::ApiException
      res = nil
    end

    if !res.nil? && res.any? then
      first = res.first

      url = "http://myanimelist.net/#{type}/#{first['id']}"
      title = first["title"].strip

      syn = @entities.decode(first["synopsis"]).strip
      truncated = syn[0..147].strip
      syn = "#{truncated}..." if syn != truncated

      if first["english"] then
        english = first["english"].strip
        maybe_english = english != title ? " (#{english})" : "";
      else
        maybe_english = ""
      end

      m.reply "#{url} #{title}#{maybe_english} -- #{syn}", true
    else
      m.reply "No results for #{type} `#{query}'", true
    end
  end
end

