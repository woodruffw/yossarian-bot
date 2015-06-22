#  -*- coding: utf-8 -*-
#  reminder.rb
#  Author: slackR | slackErEhth77
#  ------------------------
#  A Cinch plugin to set reminder  for a given time.
#  ------------------------
#  This code is licensed by slackErEhth77 under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

	class Reminder < YossarianPlugin
		include Cinch::Plugin
		use_blacklist
		
		def usage
			"!remind <count> <unit> 'Message'."
		end
		
		def match(cmd)
			cmd =~ /^(!)?remind$/
		end
	
	match /remind (\d+) (\w+) (.+)/, method: :set_reminder
		
		def convert_to_sec(count, unit)
		    if unit =~ /min/ 
				count = (count*60 )
			else
				count = (count*3600)
			end				
			
		  return count
		end
		
		def set_reminder(m, count, unit, message)
		  count = convert_to_sec(count, unit) if unit =~ /min|hour/
		  Timer(count) { m.reply "#{message}" }
		end
	end
