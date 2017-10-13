#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  flip_text.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that flips text upside down for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "flippy"

require_relative "yossarian_plugin"

class FlipText < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "!flip <down|up> <text> - Flip text upside down or rightside up."
  end

  def match?(cmd)
    cmd =~ /^(!)?flip$/
  end

  match /flip down (.+)/, method: :flip_text, strip_colors: true

  def flip_text(m, text)
    m.reply text.flip, true
  end

  match /flip up (.+)/, method: :unflip_text, strip_colors: true

  def unflip_text(m, text)
    m.reply text.unflip, true
  end
end
