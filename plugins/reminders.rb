#  -*- coding: utf-8 -*-
#  reminders.rb
#  Authors: slackR (slackErEhth77) and William Woodruff
#  ------------------------
#  A Cinch plugin to set reminders for yossarian-bot.
#  ------------------------
#  This code is licensed by slackErEhth77 under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin' 
 
class Reminders	< YossarianPlugin
	include Cinch::Plugin
	use_blacklist
	
	def usage
		'!remind <count> <unit> <message> - Set a reminder message for a time in the future.'
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
		else
			m.reply "'#{unit}' is not one of my units. Try sec(s), min(s), or hour(s).", true
			return
		end

		if secs <= 14400
			m.reply "I'll tell you about #{msg} in #{secs} second(s).", true

			Thread.new do
				sleep secs
				m.reply "#{msg}", true
			end.join
		else
			m.reply "Reminders longer than 4 hours are not allowed.", true
		end
	end
end
