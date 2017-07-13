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

require_relative 'yossarian_plugin'

class TacoRecipes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  URL = 'http://taco-randomizer.herokuapp.com/random/?full-taco=true'

  def usage
    '!taco - Get a random taco recipe from the Taco Randomizer.'
  end

  def match?(cmd)
    cmd =~ /^(!)?taco$/
  end

  match /taco$/, method: :random_taco

  def random_taco(m)
    begin
      hash = JSON.parse(open(URL).read)
      recipe_url = hash['url'].gsub(/(raw\.github.com)|(\/master\/)/, 'raw.github.com' => 'github.com', '/master/' => '/blob/master/')

      m.reply "#{hash['name']} - #{recipe_url}", true
    rescue Exception => e
      m.reply e.to_s, true
    end
  end
end
