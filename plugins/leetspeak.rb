# frozen_string_literal: true

#  bot_admin.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides leetspeak for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "leetspeak"

require_relative "yossarian_plugin"

class LeetSpeak < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "!leet <text> - Convert <text> to leetspeak."
  end

  def match?(cmd)
    cmd =~ /^(!)?leet$/
  end

  match /leet (.+)/, method: :leetspeak, strip_colors: true

  def leetspeak(m, text)
    m.reply text.leet, true
  end
end
