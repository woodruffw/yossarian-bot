#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  morse_code.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that generates Morse code for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "telegraph"

require_relative "yossarian_plugin"

class MorseCode < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "!morse <text> - Convert the given text to Morse code."
  end

  def match?(cmd)
    cmd =~ /^(!)?morse$/
  end

  match /morse (.+)/, method: :morse_code, strip_colors: true

  def morse_code(m, text)
    m.reply Telegraph.text_to_morse(text), true
  end
end
