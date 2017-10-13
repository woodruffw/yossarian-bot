#  -*- coding: utf-8 -*-
#  last_seen.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that keeps track of when users leave.
#  Based on cinch/examples/plugins/seen.rb.
#  Original authors: Lee Jarvis, Dominik Honnef
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class LastSeen < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  class LastSeenStruct < Struct.new(:who, :where, :what, :time)
    def to_s
      return "#{who} was last seen on #{time.asctime} in #{where} saying #{what}"
    end
  end

  def initialize(*args)
    super
    @users = {}
  end

  def usage
    "!seen <nick> - Check the last time <nick> was seen."
  end

  def match?(cmd)
    cmd =~ /^(!)?seen$/
  end

  listen_to :channel

  def listen(m)
    @users[m.user.nick.downcase] = LastSeenStruct.new(m.user.nick, m.channel, m.message, Time.now)
  end

  match /seen (\S+)/, method: :last_seen, strip_colors: true

  def last_seen(m, nick)
    if nick.downcase == @bot.nick.downcase
      m.reply "That\'s not going to work.", true
    elsif nick.downcase == m.user.nick.downcase
      m.reply "You\'re online right now.", true
    elsif @users.key?(nick.downcase)
      m.reply @users[nick.downcase].to_s, true
    else
      m.reply "I\'ve never seen #{nick}.", true
    end
  end
end
