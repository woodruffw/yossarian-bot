#  cleverbot.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Cleverbot interaction to yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'cleverbot-api'

class Cleverbot
	include Cinch::Plugin

	match /cb (.+)/, method: :cleverbot
	match /cleverbot (.+)/, method: :cleverbot

	def cleverbot(m, query)
		cb = CleverBot.new
		m.reply "#{m.user.nick}: #{cb.think(query)}"
	end
end
