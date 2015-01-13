#  yossarian_builtins.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides basic built-in commands for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class YossarianBuiltins < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!help [cmd] - Display general help, or help for [cmd].'
	end

	def match?(cmd)
		cmd =~ /^(!)?help$/
	end

	$BOT_VERSION = 0.99
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

	match /bots$/, method: :report_in
	def report_in(m)
		m.reply 'Reporting in! [Ruby] See !help for commands.'
	end

	match /author$/, method: :author
	def author(m)
		m.reply 'Author: cpt_yossarian (woodruffw).'
	end

	match /botver$/, method: :bot_version
	def bot_version(m)
		m.reply "yossarian-bot version #{$BOT_VERSION}."
	end

	match /src$/, method: :bot_source
	match /source$/, method: :bot_source
	def bot_source(m)
		m.reply 'https://github.com/woodruffw/yossarian-bot'
	end

	match /say (.+)/, method: :bot_say
	def bot_say(m, msg)
		m.reply msg
	end
end
