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

	def usage
		'!bi [key] - Retrieve information about the bot. See link in !help for keys. Alias: !botinfo.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(botinfo$)|(bi$)/
	end

	match /bi (\w+)/, method: :bot_info
	match /botinfo (\w+)/, method: :bot_info

	def bot_info(m, key)
		case key
		when /(^version$)|(^vers?$)/
			m.reply "yossarian-bot #{@bot.version} running on ruby #{RUBY_VERSION} (#{RUBY_PLATFORM})."
		when /(^source$)|(^src$)/
			m.reply 'yossarian-bot\'s source code can be found here: http://git.io/vs65u'
		when /(^contrib)|(^todo$)/
			m.reply 'Want to contribute? Here are some things to do: https://git.io/vwTmA'
		when /^author$/
			m.reply 'Author: William Woodruff (woodruffw, yossarian)'
		when /^uptime$/
			diff = TimeDifference.between(@bot.starttime, Time.now).in_general
			m.reply "I\'ve been online for %{days} days, %{hours} hours, %{minutes} minutes, and %{seconds} seconds." % diff
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
