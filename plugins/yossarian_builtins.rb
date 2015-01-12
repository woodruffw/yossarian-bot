#  yossarian_builtins.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides basic built-in commands for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

class YossarianBuiltins
	include Cinch::Plugin

	$BOT_VERSION = 0.99

	set :prefix, /^[.!:]/

	match /help$/, method: :help
	def help(m)
		m.reply 'Command info can be found at: https://github.com/woodruffw/yossarian-bot/blob/master/README.md', true
	end

	match /bots$/, method: :report_in
	def report_in(m)
		m.reply 'Reporting in! [Ruby] See !help for commands.'
	end

	match /author$/, method: :author
	def author(m)
		m.reply 'Author: cpt_yossarian (woodruffw).', true
	end

	match /botver$/, method: :bot_version
	def bot_version(m)
		m.reply "yossarian-bot version #{$BOT_VERSION}.", true
	end

	match /src$/, method: :bot_source
	match /source$/, method: :bot_source
	def bot_source(m)
		m.reply 'https://github.com/woodruffw/yossarian-bot', true
	end

	match /say (.+)/, method: :bot_say
	def bot_say(m, msg)
		m.reply msg
	end
end
