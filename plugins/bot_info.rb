#  -*- coding: utf-8 -*-
#  bot_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrives info on yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'time_difference'

require_relative 'yossarian_plugin'

class BotInfo < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!bi [key] - Retrieve information about the bot. Keys: ver, src, author, uptime, chans, admins. Alias: !botinfo.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(botinfo)|(bi)$/
	end

	set :prefix, /^[.!:]/

	match /bi (\w+)/, method: :bot_info
	match /botinfo (\w+)/, method: :bot_info

	def bot_info(m, key)
		case key
		when /(version)|(ver)/
			m.reply "yossarian-bot version %s." % $BOT_VERSION
		when /(source)|(src)/
			m.reply 'https://github.com/woodruffw/yossarian-bot'
		when /author/
			m.reply 'Author: woodruffw'
		when /uptime/
			diff = TimeDifference.between($BOT_STARTTIME, Time.now).in_general
			m.reply "I\'ve been online for %d days, %d hours, %d minutes, and %d seconds." % [diff[:days], diff[:hours], diff[:minutes], diff[:seconds]]
		when /chan(nel)?s/
			m.reply "Channels: %s" % @bot.channels.join(', ')
		when /admins/
			m.reply "Admins: %s" % $BOT_ADMINS.join(', ')
		else
			m.reply "I don\'t have any information on #{key}."
		end
	end
end