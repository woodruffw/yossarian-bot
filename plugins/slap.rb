#  slap.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides user slapping for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class Slap < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!slap <nick> - Slap <nick> with a large trout.'
	end

	def match?(cmd)
		cmd =~ /^(!)?slap$/
	end

	match /slap (\S+)/, method: :slap, strip_colors: true

	def slap(m, nick)
		if m.channel.users.has_key?(User(nick))
			m.action_reply "slaps #{nick} with a large trout"
		end
	end
end
