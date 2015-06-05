#  -*- coding: utf-8 -*-
#  flip_text.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that flips text upside down for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'flippy'

require_relative 'yossarian_plugin'

class FlipText < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def usage
		'!flip <text> - Flip text upside down.'
	end

	def match?(cmd)
		cmd =~ /^(!)?flip$/
	end

	match /flip (.+)/, method: :flip_text, strip_colors: true

	def flip_text(m, text)
		m.reply text.flip, true
	end
end
