#  -*- coding: utf-8 -*-
#  bot_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides interaction with MegaHAL for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "megahal"

require_relative "yossarian_plugin"

class HAL < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def initialize(*args)
    super
    @hal = MegaHAL.new
  end

  def usage
    "!hal9000 <message> - Talk to MegaHAL. Alias: !hal9k."
  end

  def match?(cmd)
    cmd =~ /^(!)?(hal9000$)|(hal9k$)/
  end

  listen_to :channel

  def listen(m)
    if m.message !~ /^[!:.]/
      @hal.reply(m.message) # train hal on channel messages
    end
  end

  match /hal9000 (.+)/, method: :hal, strip_colors: true
  match /hal9k (.+)/, method: :hal, strip_colors: true

  def hal(m, msg)
    m.reply @hal.reply(msg), true
  end
end
