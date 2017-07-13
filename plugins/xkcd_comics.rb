#  -*- coding: utf-8 -*-
#  xkcd.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides XKCD comics for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'xkcd'

require_relative 'yossarian_plugin'

class XKCDComics < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    '!xkcd [search] - Get a random XKCD comic, or one related to [search].'
  end

  def match?(cmd)
    cmd =~ /^(!)?xkcd$/
  end

  match /xkcd$/, method: :xkcd_random

  def xkcd_random(m)
    m.reply XKCD.img, true
  end

  match /xkcd (.+)/, method: :xkcd_search, strip_colors: true

  def xkcd_search(m, search)
    m.reply XKCD.search(search), true
  end
end
