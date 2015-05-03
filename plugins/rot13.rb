#  -*- coding: utf-8 -*-
#  rot13.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that rot-13 'encryption' for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class Rot13 < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!r13 <message> - \'Encrypt\' <message> with the ROT-13 cipher. Alias: !rot13.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(r13)|(rot13)$/
	end

	match /r13 (.+)/, method: :rot13
	match /rot13 (.+)/, method: :rot13

	def rot13(m, text)
		m.reply text.tr("A-Ma-mN-Zn-z", "N-Zn-zA-Ma-m"), true
	end
end
