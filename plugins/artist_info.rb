#  -*- coding: utf-8 -*-
#  artist_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that gets information about an artist from Last.fm.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'lastfm'

require_relative 'yossarian_plugin'

class ArtistInfo < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@lastfm = Lastfm.new(ENV['LASTFM_API_KEY'], ENV['LASTFM_API_SECRET'])
	end

	def usage
		'!artist <artist> - Get information about an artist from Last.fm.'
	end

	def match?(cmd)
		cmd =~ /^(!)?artist$/
	end

	match /artist (.+)/, method: :artist_info, strip_colors: true

	def artist_info(m, artist)
		if ENV.has_key?('LASTFM_API_KEY') && ENV.has_key?('LASTFM_API_SECRET')
			begin
				info = @lastfm.artist.get_info(artist: artist)

				if !info['mbid'].empty?
					name = info['name']
					url = info['url']
					formed = info['bio']['yearformed'] || '?'
					place = info['bio']['placeformed'] || '?'

					tags = info['tags']['tag'].map do |tag|
						tag['name'].capitalize
					end.join(', ')

					artists = info['similar']['artist'].map do |art|
						art['name']
					end.join(', ')

					m.reply "#{name} (formed #{formed}, #{place}): #{tags}. Similar artists: #{artists}. #{url}.", true
				else
					m.reply "No MBID found. Best guess: \'#{info['tags']['tag'][0]['name']}\'.", true
				end
			rescue Exception => e
				m.reply e.to_s.strip, true
			end
		else
			m.reply 'Internal error (missing API key).'
		end
	end
end
