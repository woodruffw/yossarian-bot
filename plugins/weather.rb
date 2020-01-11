# frozen_string_literal: true

#  weather.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides APIXU weather interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "net/http"
require "json"
require_relative "yossarian_plugin"

class Weather < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["WEATHERSTACK_API_KEY"]

  def usage
    "!w <location> - Get the weather at <location>. Alias: !weather."
  end

  def match?(cmd)
    cmd =~ /^(!)?(weather)|(^w)$/
  end

  match /w (.+)/, method: :weather, strip_colors: true
  match /weather (.+)/, method: :weather, strip_colors: true

  def weather(m, location)
    if KEY
        params = {
          :access_key => KEY,
          :query => location
        }
        uri = URI("http://api.weatherstack.com/current")
        uri.query = URI.encode_www_form(params)
        json = Net::HTTP.get(uri)
        hash = JSON.parse(json)
      if hash["location"]
        loc = hash["location"]["name"]
        loc = "#{loc}, #{hash["location"]["region"]}"
        loc = "#{loc}, #{hash["location"]["country"]}"
        weather = hash["current"]["weather_descriptions"].first
        temp_c = hash["current"]["temperature"]
        temp_f = temp_c * 1.8 + 32
        temp = "#{temp_c}°C (#{temp_f.round(2)}°F)"
        m.reply "Current temperature in #{loc} is #{temp} and #{weather}.", true
      else
        m.reply "Nothing found for location '#{location}'.", true
      end
    else
      m.reply "Internal error (missing API key)."
    end
  end
end
