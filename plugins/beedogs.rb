# frozen_string_literal: true

#  beedogs.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves pictures of Beedogs for yossarian-bot.
#  Beedogs curated by Gina Zycher: http://beedogs.com
#  Now that http://beedogs.com is dead, http://beedog.github.io is used instead.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "open-uri"

require_relative "yossarian_plugin"

class Beedogs < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "http://beedog.github.io"
  COUNT_URL = "#{URL}/count"
  IMAGE_URL = "#{URL}/image%{num}.png"

  def initialize(*args)
    super
    @count = open(COUNT_URL).read.to_i
  end

  def usage
    "!beedog - Retrieve a random picture of a beedog."
  end

  def match?(cmd)
    cmd =~ /^(!)?beedog$/
  end

  match /beedog$/, method: :beedog

  def beedog(m)
    num = rand(1..@count)
    url = IMAGE_URL % { num: num }

    m.reply url, true
  end
end
