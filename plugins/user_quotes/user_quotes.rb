#  -*- coding: utf-8 -*-
#  user_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides a collection of queryable quotes
#  for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "yaml"
require "fileutils"

require_relative "../yossarian_plugin"

class UserQuotes < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  @@user_quote_limit = 25
  @@sync_interval = 10
  @@message_count = 0

  def initialize(*args)
    super
    @quotes_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.config.server, "user_quotes.yml"))

    if File.file?(@quotes_file)
      @quotes = YAML::load_file(@quotes_file)
    else
      FileUtils.mkdir_p File.dirname(@quotes_file)
      @quotes = {}
    end
  end

  def sync_quotes_file
    File.open(@quotes_file, "w+") do |file|
      file.write @quotes.to_yaml
    end
  end

  def usage
    "!quote [nick] - Retrieve a random quote. If a nick is provided, a quote from that user is retrieved."
  end

  def match?(cmd)
    cmd =~ /^(!)?quote$/
  end

  listen_to :channel

  def listen(m)
    chan = m.channel.to_s
    nick = m.user.nick

    if m.message !~ /^[!:.]/
      @@message_count += 1

      if @quotes.key?(chan)
        if @quotes[chan].key?(nick)
          if @quotes[chan][nick].size < @@user_quote_limit
            @quotes[chan][nick] << m.message
          else
            @quotes[chan][nick].delete_at(rand(@quotes[chan][nick].length))
            @quotes[chan][nick].push(m.message)
          end
        else
          @quotes[chan][nick] = [m.message]
        end
      else
        @quotes[chan] = {}
      end

      if @@message_count == @@sync_interval
        sync_quotes_file
        @@message_count = 0
      end
    end
  end

  match /quote$/, method: :random_quote

  def random_quote(m)
    chan = m.channel.to_s

    if chan && @quotes[chan]
      nick = @quotes[chan].keys.sample
      quote = @quotes[chan][nick].sample
      m.reply "\u200B#{quote} [#{nick} on #{chan}]"
    else
      m.reply "I don\'t have any quotes on this channel yet. Check back in a bit."
    end
  end

  match /quote (\S+)/, method: :random_quote_user

  def random_quote_user(m, nick)
    chan = m.channel.to_s

    if @quotes.key?(chan) && @quotes[chan].key?(nick)
      quote = @quotes[chan][nick].sample
      m.reply "\u200B#{quote} [#{nick}]"
    else
      m.reply "I don\'t have any quotes for #{nick} on this channel."
    end
  end
end
