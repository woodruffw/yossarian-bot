#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  phone_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides phone number information lookup for yossarian-bot.
#  Uses the numverify service: https://numverify.com/
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "nokogiri"
require "json"
require "open-uri"
require "digest/md5"

require_relative "yossarian_plugin"

class PhoneInfo < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://numverify.com/php_helper_scripts/phone_api.php?secret_key=%{secret}&number=%{number}"

  def usage
    "!phoneinfo <number> - Look up information about the given phone number."
  end

  def match?(cmd)
    cmd =~ /^(!)?phoneinfo$/
  end

  match /phoneinfo (\d+)/, method: :phone_info, strip_colors: true

  def phone_info(m, number)
    # some secret...
    secret = Digest::MD5.hexdigest(Time.now.strftime "%y.%m.%d")
    url = URL % { secret: secret, number: number }

    begin
      hash = JSON.parse(open(url).read)
      hash.delete_if { |_, v| v.is_a?(String) && v.empty? }
      hash.default = "Unknown"

      if hash["valid"]
        number_fmt = hash["international_format"]
        type = hash["line_type"]
        carrier = hash["carrier"]
        location = hash["location"]
        country = hash["country_name"]

        m.reply "#{number_fmt} - Line Type: #{type} - Carrier: #{carrier} - Location: #{location}, #{country}.", true
      else
        m.reply "#{number} is not a valid phone number.", true
      end
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
