# frozen_string_literal: true

#  borzoi.rb
#  Author: William Woodruff
#  -----------------------
#  Fetches a random picture of a Borzoi from the Dog CEO API.
#  -----------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "open-uri"
require "json"

require_relative "yossarian_plugin"

class Borzoi < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://dog.ceo/api/breed/borzoi/images/random"

  def usage
    "!borzoi - Get a random Borzoi picture."
  end

  def match?(cmd)
    cmd =~ /^(!)?borzoi$/
  end

  match /borzoi$/, method: :borzoi

  def borzoi(m)
    hsh = JSON.parse(URI.open(URL).read)
    m.reply hsh["message"], true
  rescue Exception => e
    m.reply e.to_s, true
  end
end
