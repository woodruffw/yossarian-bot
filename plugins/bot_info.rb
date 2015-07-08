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
		@bot_version = 2.30
		@bot_starttime = Time.now
	end

	def usage
		'!bi [key] - Retrieve information about the bot. Keys: ver, src, author, uptime, chans, admins, ignores. Alias: !botinfo.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(botinfo$)|(bi$)/
	end

	match /bi (\w+)/, method: :bot_info
	match /botinfo (\w+)/, method: :bot_info

	def bot_info(m, key)
		case key
		when /(^version$)|(^vers?$)/
			m.reply "yossarian-bot #{@bot_version} running on ruby #{RUBY_VERSION}."
		when /(^source$)|(^src$)/
			m.reply 'https://github.com/woodruffw/yossarian-bot'
		when /^author$/
			m.reply 'Author: woodruffw'
		when /^uptime$/
			diff = TimeDifference.between(@bot_starttime, Time.now).in_general
			m.reply "I\'ve been online for %d days, %d hours, %d minutes, and %d seconds." % [diff[:days], diff[:hours], diff[:minutes], diff[:seconds]]
		when /^chan(nel)?s$/
			m.reply "Channels: %s" % @bot.channels.join(', ')
		when /^admins$/
			m.user.notice "Admins: %s" % @bot.admins.join(', ') # notice to prevent highlight bans
		when /^ignores$/
			m.reply "Ignored set: %s" % @bot.blacklist.to_a.join(', ')
		else
			m.reply "I don\'t have any information on \'#{key}\'. Try !help botinfo."
		end
	end
end
