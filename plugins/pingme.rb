# frozen_string_literal: true

#  pingme.rb
#  Author: Ckat
#  ------------------------
#  A canonical Cinch plugin for yossarian-bot.
#  combot's pingme command, lazily implemented
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class PingMe < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def initialize(*args)
    super
    @nick = ""
    @channel = ""
    @timestamp = {}
    @sent = false
  end

  def usage
    "!pingme - Get pinged"
  end

  def match?(cmd)
    cmd =~ /^(!)?pingme$/
  end

  match /pingme$/, method: :ctcp_ping_req
  listen_to :ctcp, method: :ctcp_ping_recv

  def format_ping_time
    milis = (Time.now - @timestamp) * 1000.0
    mins = (milis / 60000).to_i
    secs = (milis / 1000).to_i
    str = ""
    if mins > 0
      str = "#{str}#{mins}"
      str = "#{str}#{mins == 1 ? " Minute, " : " Minutes, "}"
    end
    if secs > 0
      str = "#{str}#{secs}"
      str = "#{str}#{secs == 1 ? " Second, " : " Seconds, "}"
    end
    return "#{str}#{((milis%60000)%1000).to_i} Milliseconds."
  end

  def ctcp_ping_req(m)
    @nick = m.user.nick
    @channel = m.channel
    @timestamp = Time.now
    User(@nick).ctcp "PING #{@timestamp.to_i}"
    @sent = true
  end

  def ctcp_ping_recv(m)
    if m.ctcp_message.include?("PING")
      if @sent
        Channel(@channel).send "#{@nick}: your ping is #{format_ping_time}"
        @sent = false
      end
    end
  end
end
