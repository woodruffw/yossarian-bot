#  -*- coding: utf-8 -*-
#  genres.rb
#  Author: Winston Weinert
#  ------------------------
#  A Cinch plugin that generates random music genres using
#  William Woodruff's genregen.
#  ------------------------
#  This code is licensed by Winston Weinert under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'
require 'genregen'

class Genres < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    '!genre - Generate a random music genre.'
  end

  def match?(cmd)
    cmd =~ /^(!)?genre$/
  end

  match /genre$/, method: :genre

  def genre(m)
    m.reply GenreGen.generate, true
  end
end
