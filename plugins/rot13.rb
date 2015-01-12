#  rot13.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that rot-13 'encryption' for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

class Rot13
	include Cinch::Plugin

	match /r13 (.+)/, method: :rot13
	match /rot13 (.+)/, method: :rot13

	def rot13(m, msg)
		m.reply "#{m.user.nick}: #{msg.tr("A-Ma-mN-Zn-z", "N-Zn-zA-Ma-m")}"
	end
end