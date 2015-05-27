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

$BOT_PLUGINS = [
	CommandHelp,
	Ping,
	BotInfo,
	BotAdmin,
	Catch22,
	UrbanDictionary,
	WolframAlpha,
	Weather,
	GoogleSearch,
	GoogleTranslate,
	YouTubeSearch,
	DuckDuckGoSearch,
	Magic8Ball,
	MerriamWebster,
	Cleverbot,
	Fortune,
	Rot13,
	TinyURL,
	GitHubInfo,
	XKCDComics,
	IsItUp,
	Hastebin,
	Slap,
	Zalgo,
	TacoRecipes,
	RainbowText,
	MorseCode,
	ShakespeareanInsults,
	LutherInsults,
	TheoQuotes,
	CBSG,
	BTC,
	WorldPopulation,
	RubyEval,
	Wikipedia,
	LeetSpeak,
	UserIntros,
	UserQuotes,
	UserMail,
	CustomTriggers,
	CTCPVersion,
	LastSeen,
	LinkTitling,
	RegexReplace
]

config_file = File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'))
config_options = {}
server_threads = []

if File.file?(config_file)
	config_options = YAML::load_file(config_file)
else
	abort('Fatal: Could not find a config.yml to load from.')
end

config_options['servers'].each do |server, info|
	server_threads << Thread.new do
		bot = Cinch::Bot.new do
			@admins = info['admins'] or []
			@blacklist = []

			def admins
				@admins
			end

			def blacklist
				@blacklist
			end

			configure do |conf|
				conf.nick = config_options['nick'] or 'yossarian-bot'
				conf.realname = 'yossarian-bot'
				conf.user = 'yossarian-bot'
				conf.max_messages = 1
				conf.server = server
				conf.channels = info['channels']
				conf.port = info['port']
				conf.ssl.use = info['ssl'] or false
				conf.plugins.prefix = Regexp.new(config_options['prefix']) or /^!/
				conf.plugins.plugins = $BOT_PLUGINS.dup

				config_options['disabled_plugins'].each do |plugin|
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
