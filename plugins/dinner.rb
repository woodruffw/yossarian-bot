#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  dinner.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves random dinner recipes for yossarian-bot.
#  Recipes curated by Zach Golden: http://whatthefuckshouldimakefordinner.com
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "nokogiri"
require "open-uri"

require_relative "yossarian_plugin"

class Dinner < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "http://whatthefuckshouldimakefordinner.com"

  def usage
    "!dinner - Retrieve a random dinner recipe."
  end

  def match?(cmd)
    cmd =~ /^(!)?dinner$/
  end

  match /dinner$/, method: :dinner

  def dinner(m)
    page = Nokogiri::HTML(open(URL).read)

    food = page.css("dl").map(&:text).join.strip.tr("\n", " ")
    link = page.css("dt")[1].css("a").first["href"]

    m.reply "#{food}. #{link}", true
  rescue Exception => e
    m.reply e.to_s, true
  end
end
