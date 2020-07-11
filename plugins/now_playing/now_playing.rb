# frozen_string_literal: true

#  now_playing.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that gets a user's last played track from Last.fm.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "yaml"
require "fileutils"
require "lastfm"

require_relative "../yossarian_plugin"

class NowPlaying < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["LASTFM_API_KEY"]
  SECRET = ENV["LASTFM_API_SECRET"]

  def initialize(*args)
    super

    @username_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.server_id, "lastfm_usernames.yml"))

    if File.file?(@username_file)
      @usernames = YAML.load_file(@username_file)
    else
      FileUtils.mkdir_p File.dirname(@username_file)
      @usernames = {}
    end

    @lastfm = Lastfm.new(KEY, SECRET) if KEY && SECRET
  end

  def sync_username_file
    File.open(@username_file, "w+") do |file|
      file.write @usernames.to_yaml
    end
  end

  def usage
    "!np [nick|link <username>] - Get a Last.fm user's last played track. Use link to associate <username> with your nick. Alias: !nowplaying."
  end

  def match?(cmd)
    cmd =~ /^(!)?(np$)|(nowplaying$)/
  end

  match /nowplaying link (\S+)/, method: :link_account, strip_colors: true
  match /np link (\S+)/, method: :link_account, strip_colors: true

  def link_account(m, username)
    @usernames[m.user.nick.downcase] = username
    sync_username_file

    m.reply "#{username} is now associated with your nick.", true
  end

  # there really ought to be a better way to do this regex
  match /nowplaying(?:$| )(\S*)/, method: :now_playing, strip_colors: true
  match /np(?:$| )(\S*)/, method: :now_playing, strip_colors: true

  def now_playing(m, nick)
    return if nick == "link" # ew

    if @lastfm
      nick = m.user.nick if nick.empty?

      username = @usernames[nick.downcase]

      if username
        begin
          info = @lastfm.user.get_recent_tracks(username, 1)

          if info
            # APIs should always return a uniform type...
            info = info.first if info.is_a?(Array)

            active = if info["nowplaying"]
                       "is now playing"
                     else
                       "last played"
                     end

            artist = info["artist"]["content"]
            song = info["name"]
            album = info["album"]["content"]

            if album
              m.reply "#{username} #{active} \"#{song}\" by #{artist} on #{album}.", true
            else
              m.reply "#{username} #{active} \"#{song}\" by #{artist}.", true
            end
          else
            m.reply "#{username} has no scrobbles.", true
          end
        rescue Exception => e
          m.reply e.to_s.strip, true
          raise e
        end
      else
        m.reply "I don\'t have a last.fm account associated with #{nick}. Add one with !np link <username>.", true
      end
    else
      m.reply "#{self.class.name}: Internal error (missing API key(s))."
    end
  end
end
