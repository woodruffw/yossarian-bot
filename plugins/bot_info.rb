#  bot_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that retrives info on yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class BotInfo < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!bi [key] - Retrieve information about the bot. Keys: ver, src, author. Alias: !botinfo.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(botinfo)|(bi)$/
	end

	$BOT_VERSION = 1.00

	match /bi (\w+)/, method: :bot_info
	match /botinfo (\w+)/, method: :bot_info

	def bot_info(m, key)
		case key
		when /(version)|(ver)/
			m.reply "yossarian-bot version #{$BOT_VERSION}."
		when /(source)|(src)/
			m.reply 'https://github.com/woodruffw/yossarian-bot'
		when /author/
			m.reply 'Author: cpt_yossarian (woodruffw)'
		end
	end
end