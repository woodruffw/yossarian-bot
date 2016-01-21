#  -*- coding: utf-8 -*-
#  now_playing.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that gets a user's last played track from Last.fm.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'lastfm'

require_relative 'yossarian_plugin'

class NowPlaying < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	KEY = ENV['LASTFM_API_KEY']
	SECRET = ENV['LASTFM_API_SECRET']

	def initialize(*args)
		super

		if KEY && SECRET
			@lastfm = Lastfm.new(KEY, SECRET)
		end
	end

	def usage
		'!np <username> - Get a Last.fm user\'s last played track. Alias: !nowplaying.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(np$)|(nowplaying$)/
	end

	match /nowplaying (.+)/, method: :now_playing, strip_colors: true
	match /np (.+)/, method: :now_playing, strip_colors: true

	def now_playing(m, username)
		if @lastfm
			begin
				info = @lastfm.user.get_recent_tracks(username, 1)

				if info
					info = info.first

					if info['nowplaying']
						active = 'is now playing'
					else
						active = 'last played'
					end

					artist = info['artist']['content']
					song = info['name']
					album = info['album']['content']

					m.reply "#{username} #{active} \"#{song}\" by #{artist} on #{album}.", true
				else
					m.reply "#{username} has no scrobbles.", true
				end
			rescue Exception => e
				m.reply e.to_s.strip, true
				raise e
			end
		else
			m.reply "#{self.class.name}: Internal error (missing API key(s))."
		end
	end
end
