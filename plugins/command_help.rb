#  command_help.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides command help for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class CommandHelp < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!help [cmd] - Display general help, or help for [cmd].'
	end

	def match?(cmd)
		cmd =~ /^(!)?help$/
	end

	set :prefix, /^[.!:]/

	match /help$/, method: :help
	def help(m)
		User(m.user).send 'Commands: http://git.io/38F1qA -- Use !help <cmd> for info.', true
	end

	match /help (.+)/, method: :help_cmd
	def help_cmd(m, cmd)
		@bot.plugins.each do |plugin|
			if plugin.match?(cmd)
				User(m.user).send m.reply plugin.usage, true
				return
			end
		end
		User(m.user).send m.reply "Nothing found for \'#{cmd}\'.", true
	end
end
