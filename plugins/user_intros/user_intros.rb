#  -*- coding: utf-8 -*-
#  user_intros.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides custom intros for users for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'yaml'
require 'fileutils'

require_relative '../yossarian_plugin'

class UserIntros < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@intros_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.config.server, 'user_intros.yml'))
		@intros = {}
	end

	def sync_intros_file
		File.open(@intros_file, "w+") do |file|
			file.write @intros.to_yaml
		end
	end

	def usage
		'!intro <command> - Manage the intro message for your nick. Commands are add, rm, and show.'
	end

	def match?(cmd)
		cmd =~ /^(!)?intro$/
	end

	listen_to :connect, method: :initialize_intros

	def initialize_intros(m)
		if File.exist?(@intros_file)
			@intros = YAML::load_file(@intros_file)
		else
			FileUtils.mkdir_p File.dirname(@intros_file)
		end
	end

	match /intro add (.+)/, method: :set_intro

	def set_intro(m, intro)
		intro.gsub!(/\x01/, '')

		if @intros.key?(m.channel.to_s)
			@intros[m.channel.to_s][m.user.nick] = intro
		else
			@intros[m.channel.to_s] = { m.user.nick => intro }
		end

		m.reply "#{m.user.nick}: Your intro for #{m.channel.to_s} has been set to: \'#{intro}\'."
		sync_intros_file
	end

	match /intro rm$/, method: :remove_intro

	def remove_intro(m)
		if @intros.key?(m.channel.to_s) && @intros[m.channel.to_s].key?(m.user.nick)
			@intros[m.channel.to_s].delete(m.user.nick)
			m.reply "#{m.user.nick}: Your intro for #{m.channel.to_s} has been removed."
			sync_intros_file
		else
			m.reply "#{m.user.nick}: You don't currently have an intro."
		end
	end

	match /intro show$/, method: :show_intro

	def show_intro(m)
		if @intros.key?(m.channel.to_s) && @intros[m.channel.to_s].key?(m.user.nick)
			m.reply "#{m.user.nick}: Your intro is currently \'#{@intros[m.channel.to_s][m.user.nick]}\'."
		else
			m.reply "#{m.user.nick}: You don't currently have an intro."
		end
	end

	listen_to :join, method: :intro_user

	def intro_user(m)
		if @intros.key?(m.channel.to_s) && @intros[m.channel.to_s].key?(m.user.nick)
			m.reply "\u200B#{@intros[m.channel.to_s][m.user.nick]}"
		end
	end
end
