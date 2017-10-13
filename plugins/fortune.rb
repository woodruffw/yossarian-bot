#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  fortune.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides random Unix fortunes for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class Fortune < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "!fortune - Get a Unix fortune."
  end

  def match?(cmd)
    cmd =~ /^(!)?fortune$/
  end

  match /fortune$/, method: :unix_fortune

  def unix_fortune(m)
    if system("which fortune 2> /dev/null")
      m.reply `fortune`.normalize_whitespace
    else
      m.reply "Internal error (no fortune)."
    end
  end
end
