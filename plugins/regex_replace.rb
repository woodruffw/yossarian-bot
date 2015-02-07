#  regex_replace.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that keeps track of a user's last message,
#  and allows them to apply a regex to it.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require_relative 'yossarian_plugin'

class RegexReplace < YossarianPlugin
	include Cinch::Plugin

	def initialize(*args)
		super
		@users = {}
	end

	listen_to :channel

	def listen(m)
		if m.message !~ /s\/([^\/]*)\/([^\/]*)(\/)?/
			@users[m.user.nick] = m.message
		end
	end

	match /s\/([^\/]*)\/([^\/]*)(\/)?/, use_prefix: false, method: :sed

	def sed(m, orig, repl)
		if @users.has_key?(m.user.nick)
			mod = @users[m.user.nick].sub(Regexp.new(orig), repl)
			m.reply "#{m.user.nick} probably meant: #{mod}"
			@users.delete(m.user.nick)
		else
			m.reply "#{m.user.nick}: No previous message to operate on."
		end
	end
end