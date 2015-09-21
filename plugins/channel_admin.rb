#  -*- coding: utf-8 -*-
#  channel_admin.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin for administrating channels for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class ChannelAdmin < YossarianPlugin
	include Cinch::Plugin
	use_blacklist
	use_auth
	use_opped

	def usage
		'!channel <commands> - Administrate the current channel (admin required). See !help for a link to channel commands.'
	end

	def match?(cmd)
		cmd =~ /^(!)?channel$/
	end

	match /channel kick (\S+) (.*)/, method: :channel_kick_nick

	def channel_kick_nick(m, nick, reason)
		if m.channel.has_user?(nick)
			m.channel.kick nick, reason
		else
			m.reply "Nobody to kick with that nickname.", true
		end
	end

	match /channel ban (\S+)/, method: :channel_ban_nick

	def channel_ban_nick(m, nick)
		if m.channel.has_user?(nick)
			m.channel.ban User(nick)
		else
			m.channel.ban "#{nick}!*@*"
		end
	end

	match /channel kickban (\S+) (.*)/, method: :channel_kickban_nick

	def channel_kickban_nick(m, nick, reason)
		if m.channel.has_user?(nick)
			m.channel.ban User(nick)
			m.channel.kick nick, reason
		else
			m.channel.ban "#{nick}!*@*"
		end
	end

	match /channel unban (\S+)/, method: :channel_unban_nick

	def channel_unban_nick(m, nick)
		matching_masks = m.channel.bans.map { |b| b.mask }.select { |m| m.nick == nick }

		if matching_masks.nonempty?
			matching_masks.each { |mask| m.channel.unban mask }
		else
			m.reply "I couldn\'t find any bans on '#{nick}'.", true
		end
	end
end
