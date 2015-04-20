#  -*- coding: utf-8 -*-
#  btc.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrieves world population estimates for yossarian-bot.
#  Data courtesy of the US census: www.census.gov/popclock/data/population/world
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'open-uri'
require 'json'

require_relative 'yossarian_plugin'

class WorldPopulation < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@url = 'https://www.census.gov/popclock/data/population/world'
	end

	def usage
		'!wp - Get the approximate world population and growth rate. Alias: !population.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(wp$)|(population$)/
	end

	match /(wp$)|(population$)/, method: :world_population

	def world_population(m)
		hash = JSON.parse(open(@url).read)
		pop = hash['world']['population']
		rate = hash['world']['population_rate']
		m.reply "World population: #{pop} (#{rate}/second)", true
	end
end
