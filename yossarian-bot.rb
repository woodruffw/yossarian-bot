#!/usr/bin/env ruby
#  -*- coding: utf-8 -*-
#  yossarian-bot.rb
#  Author: William Woodruff
#  ------------------------
#  A call-and-response IRC bot for entertainment.
#  Allows users to query UrbanDictionary, Wolfram|Alpha, and other sites.
#  Also spits out fortunes, Catch-22 quotes, and more.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'cinch'
require 'optparse'
require 'yaml'

require_relative 'lib/blacklist'

Dir[File.dirname(__FILE__) + '/plugins/**/*.rb'].each do |plugin|
	require plugin
end

$BOT_PLUGINS = []
config_file = File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'))
config_options = {}
server_threads = []

if File.file?(config_file)
	config_options = YAML::load_file(config_file)
else
	abort('Fatal: Could not find a config.yml to load from.')
end

$BOT_PLUGINS = config_options['available_plugins'].map do |plugin|
	Object.const_get(plugin)
end

config_options['servers'].each do |server_name, server_info|
	server_threads << Thread.new do
		bot = Cinch::Bot.new do
			@admins = server_info['admins'] or []
			@blacklist = []

			def admins
				@admins
			end

			def blacklist
				@blacklist
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
				conf.plugins.plugins = $BOT_PLUGINS.dup

				server_info['disabled_plugins'].each do |plugin|
					conf.plugins.plugins.delete(Object.const_get(plugin))
				end
			end

			on :message, /^[!.:,]bots$/ do |m|
				m.reply 'Reporting in! [Ruby] See !help for commands.'
			end
		end.start
	end
end

server_threads.each do |thread|
	thread.join
end
