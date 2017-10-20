#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  user_intros.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides custom intros for users for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "yaml"
require "fileutils"

require_relative "../yossarian_plugin"

class UserIntros < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  def initialize(*args)
    super
    @intros_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.config.server, "user_intros.yml"))

    if File.file?(@intros_file)
      @intros = YAML.load_file(@intros_file)
    else
      FileUtils.mkdir_p File.dirname(@intros_file)
      @intros = {}
    end
  end

  def sync_intros_file
    File.open(@intros_file, "w+") do |file|
      file.write @intros.to_yaml
    end
  end

  def usage
    "!intro <set TEXT|clear|show> - Manage the intro message for your nick."
  end

  def match?(cmd)
    cmd =~ /^(!)?intro$/
  end

  match /intro (?:add|set) (.+)/, method: :set_intro

  def set_intro(m, intro)
    intro.gsub!(/\x01/, "")

    if @intros.key?(m.channel.to_s)
      @intros[m.channel.to_s][m.user.nick] = intro
    else
      @intros[m.channel.to_s] = { m.user.nick => intro }
    end

    m.reply "Your intro for #{m.channel.to_s} has been set to: \'#{intro}\'.", true
    sync_intros_file
  end

  match /intro (clear|rm|remove|delete|del)$/, method: :remove_intro

  def remove_intro(m)
    if @intros.key?(m.channel.to_s) && @intros[m.channel.to_s].key?(m.user.nick)
      @intros[m.channel.to_s].delete(m.user.nick)
      m.reply "Your intro for #{m.channel.to_s} has been removed.", true
      sync_intros_file
    else
      m.reply "You don't currently have an intro.", true
    end
  end

  match /intro show$/, method: :show_intro

  def show_intro(m)
    if @intros.key?(m.channel.to_s) && @intros[m.channel.to_s].key?(m.user.nick)
      m.reply "Your intro is currently \'#{@intros[m.channel.to_s][m.user.nick]}\'.", true
    else
      m.reply "You don't currently have an intro.", true
    end
  end

  listen_to :join, method: :intro_user

  def intro_user(m)
    if @intros.key?(m.channel.to_s) && @intros[m.channel.to_s].key?(m.user.nick)
      m.reply "\u200B#{@intros[m.channel.to_s][m.user.nick]}"
    end
  end
end
