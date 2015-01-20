#  last_seen.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that keeps track of when users leave.
#  Based on cinch/examples/plugins/seen.rb.
#  Original authors: Lee Jarvis, Dominik Honnef
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class LastSeen < YossarianPlugin
	include Cinch::Plugin

	class LastSeenStruct < Struct.new(:who, :where, :what, :time)
		def to_s
			return "#{who} was last seen on #{time.asctime} in #{where} saying #{what}"
		end
	end

	def initialize(*args)
		super
		@users = {}
	end

	def usage
		'!seen <nick> - Check the last time <nick> was seen.'
	end

	def match?(cmd)
		cmd =~ /^(!)?seen$/
	end

	listen_to :channel
	def listen(m)
		@users[m.user.nick] = LastSeenStruct.new(m.user, m.channel, m.message, Time.now)
	end

	match /seen (\w+)/, method: :last_seen
	def last_seen(m, nick)
		if nick == @bot.nick
			m.reply "That's not going to work."
		elsif nick == m.user.nick
			m.reply "You're online right now."
		elsif @users.has_key?(nick)
			m.reply @users[nick].to_s
		else
			m.reply "I've never seen #{nick}."
		end
	end
end
