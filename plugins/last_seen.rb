#  last_seen.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that keeps track of when users leave.
#  Based on cinch/examples/plugins/seen.rb.
#  Original authors: Lee Jarvis, Dominik Honnef
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

class LastSeen
	class LastSeenStruct < Struct.new(:who, :where, :what, :time)
		def to_s
			return "#{who} was last seen on #{time.asctime} in #{where} saying #{what}"
		end
	end

	include Cinch::Plugin
	listen_to :channel
	match /seen (.+)/, method: last_seen

	def initialize(*args)
		super
		@users = {}
	end

	def listen(m)
		@users[m.user.nick] = LastSeenStruct.new(m.user, m.channel, m.message, Time.now)
	end

	def last_seen(m, nick)
		if nick == @bot.nick
			m.reply "How can I keep track of when I'm seen?"
		elsif nick == m.user.nick
			m.reply "You're online right now."
		elsif @users.has_key?(nick)
			m.reply @users[nick].to_s
		else
			m.reply "I've never seen #{nick}"
		end
	end
end
