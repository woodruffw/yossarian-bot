#  cleverbot.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Cleverbot interaction to yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'cleverbot-api'

require_relative 'yossarian_plugin'

class Cleverbot < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@cb = CleverBot.new
	end

	def usage
		'!cb <message> - Talk to CleverBot. Alias: !cleverbot.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(cb)|(cleverbot)$/
	end

	match /cb (.+)/, method: :cleverbot
	match /cleverbot (.+)/, method: :cleverbot

	def cleverbot(m, query)
		m.reply "#{m.user.nick}: #{@cb.think(query)}"
	end
end
