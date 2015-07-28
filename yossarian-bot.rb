#!/usr/bin/env ruby

#  -*- coding: utf-8 -*-
#  yossarian-bot.rb
#  Author: William Woodruff
#  ------------------------
#  A call-and-response IRC bot for entertainment.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'cinch'
require 'yaml'

require_relative 'extend/blacklist'

Dir[File.dirname(__FILE__) + '/plugins/**/*.rb'].each do |plugin|
	require plugin
end

config_file = File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'))
config_options = {}
server_threads = []

if File.file?(config_file)
	config_options = YAML::load_file(config_file)
else
	abort('Fatal: Could not find a config.yml to load from.')
end

config_options['servers'].each do |server_name, server_info|
	server_threads << Thread.new do
		bot = Cinch::Bot.new do
			@starttime = Time.now
			@version = config_options['bot_version']
			@admins = server_info['admins'] or []
			@blacklist = Set.new
			@all_plugins = config_options['available_plugins'].map do |plugin|
				Object.const_get(plugin)
			end

			def starttime
				@starttime
			end

			def version
				@version
			end

			def admins
				@admins
			end

			def blacklist
				@blacklist
			end

			def all_plugins
				@all_plugins
			end

			configure do |conf|
				conf.nick = server_info['nick'] or 'yossarian-bot'
				conf.realname = 'yossarian-bot'
				conf.user = 'yossarian-bot'
				conf.max_messages = 1
				conf.server = server_name
				conf.channels = server_info['channels']
				conf.port = server_info['port'] or 6667
				conf.ssl.use = server_info['ssl'] or false
				conf.plugins.prefix = Regexp.new(server_info['prefix']) or /^!/
				conf.plugins.plugins = @all_plugins.dup

				server_info['disabled_plugins'].each do |plugin|
					conf.plugins.plugins.delete(Object.const_get(plugin))
				end
			end
		end.start
	end
end

server_threads.each do |thread|
	thread.join
end
