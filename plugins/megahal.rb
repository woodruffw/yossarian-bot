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
		'!megahal <message> - Talk to MegaHAL.'
	end

	def match?(cmd)
		cmd =~ /^(!)?megahal$/
	end

	listen_to :channel

	def listen(m)
		if m.message !~ /^[!:.]/
			@hal.reply(m.message) # train hal on channel messages
		end
	end

	match /megahal (.+)/, method: :hal, strip_colors: true

	def hal(m, msg)
		m.reply @hal.reply(msg), true
	end
end
