#  -*- coding: utf-8 -*-
#  beer_search.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that BreweryDB interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "json"
require "open-uri"

require_relative "yossarian_plugin"

class BeerSearch < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["BREWERYDB_API_KEY"]
  URL = "http://api.brewerydb.com/v2/beers?key=%{key}&name=%{query}"

  def usage
    "!beer <name> - Search for beer information on BreweryDB."
  end

  def match?(cmd)
    cmd =~ /^(!)?beer$/
  end

  match /beer (.+)/, method: :beer_search, strip_colors: true

  def beer_search(m, search)
    if KEY
      query = URI.encode(search)
      url = URL % { key: KEY, query: query }

      begin
        hash = JSON.parse(open(url).read)

        if !hash["data"].nil?
          beer = hash["data"].first
          name = beer["name"]
          abv = beer["abv"] || "?"
          ibu = beer["ibu"] || "?"
          type = beer["style"]["name"] || "?"
          desc = beer["style"]["description"] || "?"

          m.reply "#{name} (ABV: #{abv}, IBU: #{ibu}) - #{type} - #{desc}", true
        else
          m.reply "Couldn't find '#{search}' on BreweryDB.", true
        end
      rescue Exception => e
        m.reply e.to_s, true
      end
    else
      m.reply "Internal error (missing API key)."
    end
  end
end
