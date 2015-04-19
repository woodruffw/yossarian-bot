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

Dir[File.dirname(__FILE__) + '/plugins/**/*.rb'].each do |file|
	require file
end

$BOT_ADMINS = []
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
	UserIntros,
	UserQuotes,
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

$BOT_ADMINS = config_options['admins'] or []

flags = {
	:links => true,
	:seen => true,
	:regex => true,
	:intros => true,
	:quotes => true,
	:ctcp => true,
	:triggers => true,
}

OptionParser.new do |opts|
	opts.banner = "Usage: $0 [flags]"

	opts.on('-t', '--no-link-titles', 'Do not title links.') do
		flags[:links] = false
	end

	opts.on('-s', '--no-seen', 'Disable the !seen command.') do
		flags[:seen] = false
	end

	opts.on('-r', '--no-regex-replace', 'Disable sed-like regexes for typos.') do
		flags[:regex] = false
	end

	opts.on('-i', '--no-intros', 'No custom user intros.') do
		flags[:intros] = false
	end

	opts.on('-q', '--no-quotes', 'No !quote collection.') do
		flags[:quotes] = false
	end

	opts.on('-c', '--no-ctcp-version', 'No !ver requests.') do
		flags[:ctcp] = false
	end

	opts.on('-T', '--no-custom-triggers', 'No custom triggers.') do
		flags[:triggers] = false
	end
end.parse!

config_options['servers'].each do |server, channels|
	server_threads << Thread.new do
		bot = Cinch::Bot.new do
			configure do |conf|
				conf.nick = config_options['nick'] or 'yossarian-bot'
				conf.realname = 'yossarian-bot'
				conf.user = 'yossarian-bot'
				conf.max_messages = 1
				conf.server = server
				conf.channels = channels
				conf.plugins.prefix = Regexp.new(config_options['prefix']) or /^!/
				conf.plugins.plugins = $BOT_PLUGINS.dup

				unless flags[:seen]
					conf.plugins.plugins.delete(LastSeen)
				end

				unless flags[:links]
					conf.plugins.plugins.delete(LinkTitling)
				end

				unless flags[:regex]
					conf.plugins.plugins.delete(RegexReplace)
				end

				unless flags[:intros]
					conf.plugins.plugins.delete(UserIntros)
				end

				unless flags[:quotes]
					conf.plugins.plugins.delete(UserQuotes)
				end

				unless flags[:ctcp]
					conf.plugins.plugins.delete(CTCPVersion)
				end

				unless flags[:triggers]
					conf.plugins.plugins.delete(CustomTriggers)
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
