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

require_relative 'plugins/yossarian_builtins'
require_relative 'plugins/catch22'
require_relative 'plugins/urban_dictionary'
require_relative 'plugins/wolfram_alpha'
require_relative 'plugins/weather'
require_relative 'plugins/google'
require_relative 'plugins/magic8ball'
require_relative 'plugins/merriam_webster'
require_relative 'plugins/cleverbot'
require_relative 'plugins/fortune'
require_relative 'plugins/rot13'
require_relative 'plugins/link_titling'

options = {:links => true}

OptionParser.new do |opts|
	opts.banner = "Usage: $0 <irc server> <channels> [options]"

	opts.on('-n', '--no-link-titles', 'Do not title links.') do |n|
		options[:links] = false
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
			YossarianBuiltins,
			Catch22,
			UrbanDictionary,
			WolframAlpha,
			Weather,
			Google,
			Magic8Ball,
			MerriamWebster,
			Cleverbot,
			Fortune,
			Rot13
		]

		if options[:links]
			c.plugins.plugins << LinkTitling
		end
	end
end

bot.start
