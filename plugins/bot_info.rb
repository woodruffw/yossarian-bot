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
	use_blacklist

	def initialize(*args)
		super
		@bot_version = 2.23
		@bot_starttime = Time.now
	end

	def usage
		'!bi [key] - Retrieve information about the bot. Keys: ver, src, author, uptime, chans, admins, ignores. Alias: !botinfo.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(botinfo$)|(bi$)/
	end

	set :prefix, /^[.!:]/

	match /bi (\w+)/, method: :bot_info
	match /botinfo (\w+)/, method: :bot_info

	def bot_info(m, key)
		case key
		when /(^version$)|(^ver$)/
			m.user.notice "yossarian-bot version %s." % @bot_version
		when /(^source$)|(^src$)/
			m.user.notice 'https://github.com/woodruffw/yossarian-bot'
		when /^author$/
			m.user.notice 'Author: woodruffw'
		when /^uptime$/
			diff = TimeDifference.between(@bot_starttime, Time.now).in_general
			m.user.notice "I\'ve been online for %d days, %d hours, %d minutes, and %d seconds." % [diff[:days], diff[:hours], diff[:minutes], diff[:seconds]]
		when /^chan(nel)?s$/
			m.user.notice "Channels: %s" % @bot.channels.join(', ')
		when /^admins$/
			m.user.notice "Admins: %s" % @bot.admins.join(', ')
		when /^ignores$/
			m.user.notice "Ignored hosts: %s" % @bot.blacklist.join(', ')
		else
			m.user.notice "I don\'t have any information on \'#{key}\'. Try !help botinfo."
		end
	end
end