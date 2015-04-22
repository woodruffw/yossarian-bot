#  -*- coding: utf-8 -*-
#  taco_recipes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides random taco recipes to yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'
require 'haste'

require_relative 'yossarian_plugin'

class TacoRecipes < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@url = 'http://taco-randomizer.herokuapp.com/random/?full-taco=true'
	end

	def usage
		'!taco - Get a random taco recipe from the Taco Randomizer.'
	end

	def match?(cmd)
		cmd =~ /^(!)?taco$/
	end

	match /taco$/, method: :random_taco

	def random_taco(m)
		hash = JSON.parse(open(@url).read)
		recipe_url = hash['url'].gsub(/(raw\.github.com)|(\/master\/)/, 'raw.github.com' => 'github.com', '/master/' => '/tree/master/')

		m.reply "#{hash['name']} - #{recipe_url}", true
	end
end
