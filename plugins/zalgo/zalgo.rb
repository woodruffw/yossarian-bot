#  -*- coding: utf-8 -*-
#  zalgo.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that summons Zalgo.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative "../yossarian_plugin"
require_relative "zalgo_text"

class Zalgo < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!zalgo <text> - Summon Zalgo with the given text.'
	end

	def match?(cmd)
		cmd =~ /(!)?zalgo$/
	end

	match /zalgo (.+)/, method: :zalgo, strip_colors: true

	def zalgo(m, text)
		m.reply ZalgoText.he_comes(text, {:up => false, :down => false})
	end
end