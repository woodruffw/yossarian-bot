#!/usr/bin/env ruby

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

require_relative 'plugins/command_help'
require_relative 'plugins/bot_info'
require_relative 'plugins/catch22'
require_relative 'plugins/urban_dictionary'
require_relative 'plugins/wolfram_alpha'
require_relative 'plugins/weather'
require_relative 'plugins/google'
require_relative 'plugins/youtube'
require_relative 'plugins/magic8ball'
require_relative 'plugins/merriam_webster'
require_relative 'plugins/cleverbot'
require_relative 'plugins/fortune'
require_relative 'plugins/rot13'
require_relative 'plugins/last_seen'
require_relative 'plugins/tiny_url'
require_relative 'plugins/link_titling'

options = {:links => true, :seen => true}

OptionParser.new do |opts|
	opts.banner = "Usage: $0 <irc server> <channels> [options]"

	opts.on('-t', '--no-link-titles', 'Do not title links.') do |t|
		options[:links] = false
	end

	opts.on('-s', '--no-seen', 'Disable the !seen command.') do |s|
		options[:seen] = false
	end
end.parse!

bot = Cinch::Bot.new do
	configure do |c|
		c.nick = "yossarian-bot"
		c.realname = "yossarian-bot"
		c.max_messages = 1
		c.server = ARGV[0]
		c.channels = ARGV[1].split(',')
		c.plugins.prefix = /^!/
		c.plugins.plugins = [
			CommandHelp,
			BotInfo,
			Catch22,
			UrbanDictionary,
			WolframAlpha,
			Weather,
			Google,
			YouTube,
			Magic8Ball,
			MerriamWebster,
			Cleverbot,
			Fortune,
			Rot13,
			TinyURL
		]

		if options[:seen]
			c.plugins.plugins << LastSeen
		end

		if options[:links]
			c.plugins.plugins << LinkTitling
		end
	end

	on :message, /^[!.:,]bots$/ do |m|
		m.reply 'Reporting in! [Ruby] See !help for commands.'
	end
end

bot.start
