# frozen_string_literal: true

#  weather.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides OpenWeather interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'openweathermap'
require_relative "yossarian_plugin"

class Weather < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["OPENWEATHER_API_KEY"]

  def usage
    "!w [c/f] <location> - Get the weather at <location>. Alias: !weather."
  end

  def match?(cmd)
    cmd =~ /^(!)?(weather)|(^w)$/
  end

  # default to f
  match /w (?![fc])(.+)/, method: :fweather, strip_colors: true
  match /weather (?![fc])(.+)/, method: :fweather, strip_colors: true
  match /w f (.+)/, method: :fweather, strip_colors: true
  match /weather f (.+)/, method: :fweather, strip_colors: true
  match /w c (.+)/, method: :cweather, strip_colors: true
  match /weather c (.+)/, method: :cweather, strip_colors: true

  def fweather(m, location)
    if KEY
      begin
        api = OpenWeatherMap::API.new(KEY, 'en', 'imperial')
        cw = api.current(location)
      rescue OpenWeatherMap::Exceptions::UnknownLocation
        m.reply "Bad query for location \'#{location}\'.", true
      rescue OpenWeatherMap::Exceptions::Unauthorized
        m.reply "Bad query: Unauthorized", true
      else
        loc =  "#{cw.city.country}, #{cw.city.name}"
        weather = "#{cw.weather_conditions.description} #{cw.weather_conditions.emoji}"
        temp = cw.weather_conditions.temperature
        m.reply "Current temperature in #{loc} is #{temp}°F and #{weather}", true
      end
    else
      m.reply "#{self.class.name}: Internal error (missing API key)."
    end
  end

  def cweather(m, location)
    if KEY
      begin
        api = OpenWeatherMap::API.new(KEY, 'en', 'metric')
        cw = api.current(location)
      rescue OpenWeatherMap::Exceptions::UnknownLocation
        m.reply "Bad query for location \'#{location}\'.", true
      rescue OpenWeatherMap::Exceptions::Unauthorized
        m.reply "Bad query: Unauthorized", true
      else
        loc =  "#{cw.city.country}, #{cw.city.name}"
        weather = "#{cw.weather_conditions.description} #{cw.weather_conditions.emoji}"
        temp = cw.weather_conditions.temperature
        m.reply "Current temperature in #{loc} is #{temp}°C and #{weather}", true
      end
    else
      m.reply "#{self.class.name}: Internal error (missing API key)."
    end
  end
end
