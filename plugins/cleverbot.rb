#  -*- coding: utf-8 -*-
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
	use_blacklist

	def initialize(*args)
		super
		@cb = CleverBot.new
	end

	def usage
		'!cb <message> - Talk to CleverBot. Alias: !cleverbot.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(cb$)|(cleverbot$)/
	end

	match /cb (.+)/, method: :cleverbot, strip_colors: true
	match /cleverbot (.+)/, method: :cleverbot, strip_colors: true

	def cleverbot(m, query)
		m.reply @cb.think(query), true
	end
end
