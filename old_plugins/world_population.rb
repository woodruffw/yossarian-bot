#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  btc.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves world population estimates for yossarian-bot.
#  Data courtesy of the US census: www.census.gov/popclock/data/population/world
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "open-uri"
require "json"

require_relative "yossarian_plugin"

class WorldPopulation < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = "https://www.census.gov/popclock/data/population/world"

  def usage
    "!wp - Get the approximate world population and growth rate. Alias: !population."
  end

  def match?(cmd)
    cmd =~ /^(!)?(wp$)|(population$)/
  end

  match /(wp$)|(population$)/, method: :world_population

  def world_population(m)
    begin
      hash = JSON.parse(open(URL).read)
      pop = hash["world"]["population"]
      rate = hash["world"]["population_rate"]
      m.reply "World population: #{pop} (#{rate}/second)", true
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
