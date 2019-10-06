# frozen_string_literal: true

#  ping.rb
#  Author: William Woodruff
#  ------------------------
#  A canonical Cinch plugin for yossarian-bot.
#  Responds to a user's 'ping' with a 'pong'.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class Ping < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def initialize(*args)
    super
    @nick = ""
    @channel = ""
    @timestamp = {}
    @thread = Thread.current
    @thread[:ping_sent] = false
  end

  def usage
    "!ping - Ping the bot for a timestamped response."
  end

  def match?(cmd)
    cmd =~ /^(!)?ping$/
  end

  def format_ping_time
    milis = (Time.now - @timestamp) * 1000.0
    mins = (milis / 60000).to_i
    secs = (milis / 1000).to_i
    str = ""
    if mins > 0
      str = "#{str}#{mins}"
      str = "#{str}#{mins == 1 ? " minute, " : " minutes, "}"
    end
    if secs > 0
      str = "#{str}#{secs}"
      str = "#{str}#{secs == 1 ? " second, " : " seconds, "}"
    end
    return "#{str}#{((milis%60000)%1000).to_i} milliseconds"
  end

  match /ping$/, method: :ctcp_ping_req
  listen_to :ctcp, method: :ctcp_ping_recv

  def ctcp_ping_req(m)
    @nick = m.user.nick
    @channel = m.channel
    @timestamp = Time.now
    User(@nick).ctcp "PING #{@timestamp.to_i}"
    @thread[:ping_sent] = true
  end

  def ctcp_ping_recv(m)
    if m.ctcp_message.include?("PING")
      if @thread[:ping_sent]
        Channel(@channel).send "#{@nick}: pong #{@timestamp.to_i} (#{format_ping_time})"
        @thread[:ping_sent] = false
      end
    end
  end
end
