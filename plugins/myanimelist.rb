#  -*- coding: utf-8 -*-
#  myanimelist.rb
#  Author: Winston Weinert
#  ------------------------
#  A Cinch plugin that provides MyAnimeList search interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by Winston Weinert under the MIT License.
#  http://opensource.org/licenses/MIT

require 'htmlentities'
require 'myanimelist'

require_relative 'yossarian_plugin'

class MyAnimeListSearch < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def initialize(*args)
    super
    MyAnimeList.configure do |cfg|
      cfg.username = ENV['MAL_USERNAME']
      cfg.password = ENV['MAL_PASSWORD']
    end
    @entities = HTMLEntities.new
  end

  def usage
    '!<anime|manga> <search> - Search MyAnimeList for anime or manga.'
  end

  def match?(cmd)
    cmd =~ /^(!)?(anime|manga)$/
  end

  match /(anime|manga) (.+)/, method: :search, strip_colors: true

  def search(m, type, query)
    begin
      res = type == 'anime' ? MyAnimeList.search_anime(query) : MyAnimeList.search_manga(query)
    rescue MyAnimeList::ApiException
      m.reply 'No results for ' + type + ' "' + query + '".', true
      return
    end

    if res.any? then
      first = res.first
      s = 'http://myanimelist.net/' + type + '/' + first['id']
      s << ' ' + first['title'] + ' '
      if first['english'] && first['english'] != first['title'] then
        s << '(' + first['english'] + ') '
      end
      syn = @entities.decode(first['synopsis'])
      truncated = syn[0..147]
      syn = truncated + '...' if syn != truncated
      s << '-- ' + syn
      m.reply s, true
    else
      m.reply 'No results for ' + type + ' "' + query + '".', true
    end
  end
end

