# frozen_string_literal: true

#  reminders.rb
#  Authors: slackR (slackErEhth77) and William Woodruff
#  ------------------------
#  A Cinch plugin to set reminders for yossarian-bot.
#  ------------------------
#  This code is licensed by slackErEhth77 under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "yossarian_plugin"

class Reminders < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def initialize(*args)
    super
    @threads = 0
  end

  def usage
    "!remind <count> <unit> <message> - Set a reminder message for a time in the future."
  end

  def match(cmd)
    cmd =~ /^(!)?remind$/
  end

  match /remind (\d+) (\w+) (.+)/, method: :set_reminder

  def set_reminder(m, count, unit, msg)
    msg = Sanitize(msg)
    count = Integer(count).abs

    case unit
    when /^sec/
      secs = count
    when /^min/
      secs = count * 60
    when /^hour/
      secs = count * 3600
    when /^day/
      secs = count * 86400
    else
      m.reply "'#{unit}' is not one of my units. Try sec(s), min(s), or hour(s).", true
      return
    end

    if secs <= 604800 && @threads < 5
      m.reply "I'll tell you about #{msg} in #{secs} second(s).", true

      Thread.new do
        @threads += 1
        sleep secs
        m.reply "#{msg}", true
        @threads -= 1
      end.join
    elsif @threads >= 5
      m.reply "I already have a maximum number of reminders pending.", true
    else
      m.reply "Reminders longer than 7 days are not allowed.", true
    end
  end
end
