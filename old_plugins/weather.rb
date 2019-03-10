# frozen_string_literal: true

#  weather.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Weather Underground interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "wunderground"

require_relative "yossarian_plugin"

class Weather < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["WUNDERGROUND_API_KEY"]

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
      wu = Wunderground.new(KEY)
      hash = wu.conditions_for(location)

      if hash["current_observation"]
        loc = hash["current_observation"]["display_location"]["full"]
        weather = hash["current_observation"]["weather"]
        temp = hash["current_observation"]["temperature_string"]
        m.reply "Current temperature in #{loc} is #{temp} and #{weather}.", true
      else
        m.reply "Bad query for location \'#{location}\'.", true
      end
    else
      m.reply "#{self.class.name}: Internal error (missing API key)."
    end
  end
end
