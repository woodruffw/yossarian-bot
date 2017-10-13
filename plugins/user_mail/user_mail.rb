#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  user_mail.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides user mailboxes for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "yaml"
require "fileutils"

require_relative "../yossarian_plugin.rb"

class UserMail < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  class MboxMessageStruct < Struct.new(:sender, :time, :message)
    def to_s
      stamp = time.strftime "%H:%M:%S"
      "[#{stamp}] <#{sender}> - #{message}"
    end
  end

  def initialize(*args)
    super
    @mbox_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.config.server, "user_mail.yml"))

    if File.file?(@mbox_file)
      @mbox = YAML::load_file(@mbox_file)
      @mbox.default_proc = Proc.new { |h, k| h[k] = [] }
    else
      FileUtils.mkdir_p File.dirname(@mbox_file)
      @mbox = Hash.new { |h, k| h[k] = [] }
    end
  end

  def sync_mbox_file
    File.open(@mbox_file, "w+") do |file|
      file.write @mbox.to_yaml
    end
  end

  def usage
    "!mail <nick> <message> - Send a message to a nick. Messages are delivered the next time the nick speaks."
  end

  def match?(cmd)
    cmd =~ /^(!)?mail$/
  end

  listen_to :channel

  def listen(m)
    nick = m.user.nick.downcase

    if @mbox.key?(nick)
      m.user.send "Here is your mail. Use !mail <nick> <message> to reply in turn."

      @mbox[nick].each do |msg|
        m.user.send msg.to_s
      end
      @mbox.delete(nick)
      sync_mbox_file
    end
  end

  match /mail (\S+) (.+)/, method: :mail

  def mail(m, nick, msg)
    if nick.downcase == @bot.nick.downcase
      m.reply 'That\'s not going to work.', true
    else
      @mbox[nick.downcase] << MboxMessageStruct.new(m.user.nick, Time.now, msg)

      m.reply "I\'ll give your message to #{nick} the next time I see them.", true
      sync_mbox_file
    end
  end
end

