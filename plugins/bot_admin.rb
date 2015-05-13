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
	use_blacklist

	def usage
		'!admin <commands> - Control bot operation with <commands>. See !help for a link to admin commands.'
	end

	def match?(cmd)
		cmd =~ /^(!)?admin$/
	end

	def authenticate?(nick)
		@bot.admins.include?(nick) && User(nick).authed?
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
			m.reply "Available plugins: #{plugins}", true
			@bot.config.max_messages = 1
		else
			m.reply "You do not have permission to do that.", true
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
			m.reply "#{name} is already enabled or does not exist.", true
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin disable (\w+)/, method: :plugin_disable

	def plugin_disable(m, name)
		if authenticate?(m.user.nick)
			@bot.plugins.each do |plugin|
				if plugin.class.name == name
					@bot.plugins.unregister_plugin(plugin)
					m.reply "#{name} has been disabled.", true
					return
				end
			end
			m.reply "#{name} is already disabled or does not exist.", true
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin quit/, method: :bot_quit

	def bot_quit(m)
		if authenticate?(m.user.nick)
			m.reply 'Goodbye!'
			@bot.quit
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin auth (\S+)/, method: :bot_add_admin

	def bot_add_admin(m, nick)
		if authenticate?(m.user.nick)
			unless @bot.admins.include?(nick)
				@bot.admins << nick
				m.reply "Added #{nick} as an admin.", true
			else
				m.reply "#{nick} is already an admin.", true
			end
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin deauth (\S+)/, method: :bot_remove_admin

	def bot_remove_admin(m, nick)
		if authenticate?(m.user.nick)
			if @bot.admins.include?(nick)
				@bot.admins.delete(nick)
				m.reply "#{nick} is no longer an admin.", true
			else
				m.reply "No admin \'#{nick}\' to remove.", true
			end
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin join (\S+)/, method: :bot_join_channel

	def bot_join_channel(m, chan)
		if authenticate?(m.user.nick)
			if !@bot.channels.include?(chan)
				@bot.join(chan)
				m.reply "I\'ve joined #{chan}.", true
			else
				m.reply "I\'m already in #{chan}!", true
			end
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin leave (\S+)/, method: :bot_leave_channel

	def bot_leave_channel(m, chan)
		if authenticate?(m.user.nick)
			if @bot.channels.include?(chan)
				m.reply "I\'m leaving #{chan}.", true
				@bot.part(chan)
			else
				m.reply "I\'m not in that channel.", true
			end
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin ignore (\S+)/, method: :bot_ignore_nick

	def bot_ignore_nick(m, nick)
		if authenticate?(m.user.nick)
			host = User(nick).host

			unless @bot.blacklist.include?(host)
				@bot.blacklist << host
				m.reply "Ignoring messages from #{host} (#{nick}).", true
			else
				m.reply "I\'m already ignoring that host.", true
			end
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin unignore (\S+)/, method: :bot_unignore_nick

	def bot_unignore_nick(m, nick)
		if authenticate?(m.user.nick)
			host = User(nick).host

			if @bot.blacklist.include?(host)
				@bot.blacklist.delete(host)
				m.reply "No longer ignoring #{host} (#{nick}).", true
			else
				m.reply "I\'m not currently ignoring that host.", true
			end
		else
			m.reply "You do not have permission to do that.", true
		end
	end

    match /admin nick (\S+)/, method: :bot_nick

    def bot_nick(m, nick)
        if authenticate?(m.user.nick)
            m.reply "Changing my nickname to #{nick}.", true
            @bot.nick = nick
        else
            m.reply "You do not have permission to do that.", true
        end
    end

	match /admin say (#\S+) (.+)/, method: :bot_say

	def bot_say(m, chan, msg)
		if authenticate?(m.user.nick)
			Channel(chan).send msg
		else
			m.reply "You do not have permission to do that.", true
		end
	end

	match /admin act (#\S+) (.+)/, method: :bot_act

	def bot_act(m, chan, msg)
		if authenticate?(m.user.nick)
			Channel(chan).action msg
		else
			m.reply "You do not have permission to do that.", true
		end
	end
end
