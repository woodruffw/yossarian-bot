# frozen_string_literal: true

#  weather.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides APIXU weather interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'bundler/setup' # needed for apixu
require 'apixu'
require_relative "yossarian_plugin"

class Weather < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["APIXU_API_KEY"]

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
      begin
        client = Apixu::Client.new KEY
        hash = client.current location
      rescue Apixu::Errors::Request => e
        m.reply e, true
      else
        loc = "#{hash["location"]["name"]}, #{hash["location"]["region"]}, #{hash["location"]["country"]}"
        weather = hash["current"]["condition"]["text"]
        temp = "#{hash["current"]["temp_c"]}°C (#{hash["current"]["temp_f"]}°F)"
        m.reply "Current temperature in #{loc} is #{temp} and #{weather}.", true
      end
    else
      m.reply "#{self.class.name}: Internal error (missing API key)."
    end
  end
end
