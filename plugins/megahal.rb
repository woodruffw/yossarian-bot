#  -*- coding: utf-8 -*-
#  bot_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides interaction with MegaHAL for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'megahal'

require_relative 'yossarian_plugin'

class HAL < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@hal = MegaHAL.new
	end

	def usage
		'!hal <message> - Talk to MegaHAL.'
	end

	def match?(cmd)
		cmd =~ /^(!)?hal$/
	end

	match /hal (.+)/, method: :hal, strip_colors: true

	def hal(m, msg)
		m.reply @hal.reply(msg), true
	end
end
