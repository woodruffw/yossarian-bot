#  -*- coding: utf-8 -*-
#  ibip.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides IBIP compatibility for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class IBIP < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def usage
    "[.!:]bots - Announce this bot to the channel."
  end

  def match?(cmd)
    cmd =~ /^([.!:])?bots$/
  end

  match /bots$/, method: :ibip, prefix: /^[.!:]/

  def ibip(m)
    m.reply "Reporting in! [Ruby] See !help."
  end
end
