#  bot_admin.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin for administrating yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class BotAdmin < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!admin <commands> - control bot operation with <commands>. Available commands: enable|disable <plugin>, quit, say.'
	end

	def match?(cmd)
		cmd =~ /^(!)?admin$/
	end

	def authenticate?(nick)
		nick == $BOT_ADMIN && !$BOT_ADMIN.empty?
	end

	match /admin enable (\w+)/, method: :plugin_enable

	def plugin_enable(m, cmd)
		if authenticate?(m.user.nick)
			m.reply "#{m.user.nick}: Not yet implemented."
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin disable (\w+)/, method: :plugin_disable

	def plugin_disable(m, cmd)
		if authenticate?(m.user.nick)
			@bot.plugins.each do |plugin|
				if plugin.match?(cmd)
					@bot.plugins.unregister_plugin(plugin)
					m.reply "#{m.user.nick}: Disabled a plugin matching \'#{cmd}\'."
					return
				end
			end
			m.reply "#{m.user.nick}: Could not find any plugins matching \'#{cmd}\'."
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin quit/, method: :bot_quit

	def bot_quit(m)
		if authenticate?(m.user.nick)
			m.reply 'Goodbye!'
			@bot.quit
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin say (.+)/, method: :bot_say

	def bot_say(m, msg)
		if authenticate?(m.user.nick)
			m.reply msg
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end
end
