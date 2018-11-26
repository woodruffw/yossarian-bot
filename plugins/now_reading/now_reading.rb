# frozen_string_literal: true

#  now_playing.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that gets a user's current books on Goodreads.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "yaml"
require "fileutils"
require "goodreads"

require_relative "../yossarian_plugin"

class NowReading < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["GOODREADS_API_KEY"]

  def initialize(*args)
    super

    @username_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.config.server, "goodreads_usernames.yml"))

    if File.file?(@username_file)
      @user_ids = YAML.load_file(@username_file)
    else
      FileUtils.mkdir_p File.dirname(@username_file)
      @user_ids = {}
    end

    @goodreads = Goodreads.new(api_key: KEY)
  end

  def sync_user_id_file
    File.open(@username_file, "w+") do |file|
      file.write @user_ids.to_yaml
    end
  end

  def usage
    "!nr [nick|link <userid>] - Get a Goodreads user's current book(s). Use link to associate <userid> with your nick. Aliases: !nowreading, !gr."
  end

  def match?(cmd)
    cmd =~ /^(!)?(nr$)|(nowreading$)/
  end

  match /nowreading link (\S+)/, method: :link_account, strip_colors: true
  match /nr link (\S+)/, method: :link_account, strip_colors: true
  match /gr link (\S+)/, method: :link_account, strip_colors: true

  def link_account(m, user_id)
    if user_id =~ /\A\d+\z/
      @user_ids[m.user.nick.downcase] = user_id
      sync_user_id_file

      m.reply "#{user_id} is now associated with your nick.", true
    else
      m.reply "That doesn't look like a valid Goodreads user ID.", true
    end
  end

  # there really ought to be a better way to do this regex
  match /nowreading(?:$| )(\S*)/, method: :now_reading, strip_colors: true
  match /nr(?:$| )(\S*)/, method: :now_reading, strip_colors: true
  match /gr(?:$| )(\S*)/, method: :now_reading, strip_colors: true

  def now_reading(m, nick)
    return if nick == "link" # ew

    nick = m.user.nick if nick.empty?

    user_id = @user_ids[nick.downcase]

    if user_id
      begin
        books = @goodreads.shelf(user_id, "currently-reading").books.map(&:book)
        username = @goodreads.user(user_id).user_name

        if books.nonempty?
          # 4 is a good limit
          nbooks = [books.size, 4].min

          reading = nbooks.times.map do |i|
            authors = books[i].authors.map { |_, author| author.name }.join ", "
            "#{books[i].title} (#{authors})"
          end.join ", "

          m.reply "#{username} is currently reading #{reading}.", true
        else
          m.reply "#{nick} (#{user_id}) isn't currently reading anything.", true
        end
      rescue Goodreads::NotFound => e
        m.reply "I couldn't find a Goodreads user with ID: #{user_id}.", true
      rescue Exception => e
        m.reply e.to_s, true
      end
    else
      m.reply "I don\'t have a Goodreads account associated with #{nick}. Add one with !nr link <userid>.", true
    end
  end
end
