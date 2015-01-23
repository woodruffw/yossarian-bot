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
		'!admin <commands> - control bot operation with <commands>. Available commands: enable|disable|list <plugin>, quit, say.'
	end

	def match?(cmd)
		cmd =~ /^(!)?admin$/
	end

	def authenticate?(nick)
		nick == $BOT_ADMIN && !$BOT_ADMIN.empty?
	end

	match /admin list/, method: :plugin_list

	def plugin_list(m)
		if authenticate?(m.user.nick)
			User(m.user).send "Active plugins: %s" % @bot.plugins.map { |p| p.class }.join(', '), true
			User(m.user).send "Available plugins: %s" % $BOT_PLUGINS.map { |p| p.name }.join(', '), true
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end


	match /admin enable (\w+)/, method: :plugin_enable

	def plugin_enable(m, name)
		if authenticate?(m.user.nick)
			$BOT_PLUGINS.each do |plugin|
				if plugin.name == name && !@bot.plugins.include?(plugin)
					@bot.plugins.register_plugin(plugin)
					m.reply "#{m.user.nick}: #{name} has been enabled."
					return
				end
			end
			m.reply "#{m.user.nick}: #{name} is already enabled or does not exist."
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin disable (\w+)/, method: :plugin_disable

	def plugin_disable(m, name)
		if authenticate?(m.user.nick)
			@bot.plugins.each do |plugin|
				if plugin.class.name == name
					@bot.plugins.unregister_plugin(plugin)
					m.reply "#{m.user.nick}: Disabled #{name}."
					return
				end
			end
			m.reply "#{m.user.nick}: #{name} is already disabled or does not exist."
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
			Channel(m.channel).send msg
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end
end
