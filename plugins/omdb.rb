# frozen_string_literal: true

#  -*- coding: utf-8 -*-
#  omdb.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that gets movie/show info from the OMDB for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "json"
require "open-uri"

require_relative "yossarian_plugin"

class OMDB < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://www.omdbapi.com/?t=%<query>s&plot=short&r=json&apikey=%<key>s"

  def usage
    "!omdb <title> - Look up a movie or show on the Open Movie Database."
  end

  def match?(cmd)
    cmd =~ /^(!)?omdb$/
  end

  match /omdb (.+)/, method: :omdb_search, strip_colors: true

  def omdb_search(m, title)
    query = URI.encode(title)
    url = URL % { query: query, key: ENV["OMDB_API_KEY"] }

    begin
      hash = JSON.parse(open(url).read)
      hash.default = "?"

      if !hash.key?("Error")
        title = hash["Title"]
        year = hash["Year"]
        genres = hash["Genre"]
        plot = hash["Plot"]
        imdb_rating = hash["imdbRating"]
        imdb_link = "http://imdb.com/title/#{hash["imdbID"]}"

        m.reply "#{title} (#{year}) (#{genres}). #{plot} IMDB rating: #{imdb_rating}/10. More at #{imdb_link}.", true
      else
        m.reply "Error: #{hash["Error"]}", true
      end
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
