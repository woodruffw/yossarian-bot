#  -*- coding: utf-8 -*-
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
		'!admin <commands> - Control bot operation with <commands>. See !help for a link to admin commands.'
	end

	def match?(cmd)
		cmd =~ /^(!)?admin$/
	end

	def authenticate?(nick)
		$BOT_ADMINS.include?(nick) && !$BOT_ADMINS.empty?
	end

	match /admin plugin list/, method: :plugin_list

	def plugin_list(m)
		if authenticate?(m.user.nick)
			all_plugin_names = $BOT_PLUGINS.map { |p| p.name }
			active_plugin_names = @bot.plugins.map { |p2| p2.class.name }

			plugins = all_plugin_names.map do |apn|
				Format(active_plugin_names.include?(apn) ? :green : :red, apn)
			end.join(', ')

			# temporarily allow up to two messages due to to long plugin lists
			@bot.config.max_messages = 2
			m.reply "#{m.user.nick}: Available plugins: #{plugins}"
			@bot.config.max_messages = 1
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
					m.reply "#{m.user.nick}: #{name} has been disabled."
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

	match /admin auth (\S+)/, method: :bot_add_admin

	def bot_add_admin(m, nick)
		if authenticate?(m.user.nick)
			$BOT_ADMINS << nick
			m.reply "#{m.user.nick}: Added #{nick} as an admin."
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin deauth (\S+)/, method: :bot_remove_admin

	def bot_remove_admin(m, nick)
		if authenticate?(m.user.nick)
			if $BOT_ADMINS.include?(nick)
				$BOT_ADMINS.delete(nick)
				m.reply "#{m.user.nick}: #{nick} is no longer an admin."
			else
				m.reply "#{m.user.nick}: No admin \'#{nick}\' to remove."
			end
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin join (\S+)/, method: :bot_join_channel

	def bot_join_channel(m, chan)
		if authenticate?(m.user.nick)
			if !@bot.channels.include?(chan)
				@bot.join(chan)
				m.reply "#{m.user.nick}: I\'ve joined #{chan}."
			else
				m.reply "#{m.user.nick}: I\'m already in #{chan}!"
			end
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin leave (\S+)/, method: :bot_leave_channel

	def bot_leave_channel(m, chan)
		if authenticate?(m.user.nick)
			if @bot.channels.include?(chan)
				m.reply "#{m.user.nick}: I\'m leaving #{chan}."
				@bot.part(chan)
			else
				m.reply "#{m.user.nick}: I\'m not in the channel."
			end
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin say (#\S+) (.+)/, method: :bot_say

	def bot_say(m, chan, msg)
		if authenticate?(m.user.nick)
			Channel(chan).send msg
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end

	match /admin act (#\S+) (.+)/, method: :bot_act

	def bot_act(m, chan, msg)
		if authenticate?(m.user.nick)
			Channel(chan).action msg
		else
			m.reply "#{m.user.nick}: You do not have permission to do that."
		end
	end
end
