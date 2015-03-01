#  -*- coding: utf-8 -*-
#  ctcp_version.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that sends CTCP VERSION requests to users.
#  Original authors: Lee Jarvis, Dominik Honnef
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class CTCPVersion < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@nick = ''
		@channel = ''
	end

	def usage
		'!ver <nick> - Send a CTCP VERSION request to <nick>. Alias: !version.'
	end

	def match?(cmd)
		cmd =~ /^(!)?ver(?:sion)?$/
	end

	match /ver(?:sion)? (\S+)/, method: :ctcp_ver_req

	def ctcp_ver_req(m, nick)
		if m.channel.users.has_key?(User(nick))
			User(nick).ctcp 'VERSION'
			@nick = m.user.nick
			@channel = m.channel
		end
	end

	listen_to :ctcp, method: :ctcp_ver_recv

	def ctcp_ver_recv(m)
		if m.ctcp_message.include?('VERSION')
			version = m.ctcp_message.sub('VERSION ', '')
			Channel(@channel).send "#{@nick}: #{m.user.nick} is using #{version}."
		end
	end
end
