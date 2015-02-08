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
require_relative 'plugins/bot_admin'
require_relative 'plugins/catch22'
require_relative 'plugins/urban_dictionary'
require_relative 'plugins/wolfram_alpha'
require_relative 'plugins/weather'
require_relative 'plugins/google_search'
require_relative 'plugins/youtube_search'
require_relative 'plugins/magic8ball'
require_relative 'plugins/merriam_webster'
require_relative 'plugins/cleverbot'
require_relative 'plugins/fortune'
require_relative 'plugins/rot13'
require_relative 'plugins/last_seen'
require_relative 'plugins/tiny_url'
require_relative 'plugins/github_info'
require_relative 'plugins/xkcd_comics'
require_relative 'plugins/isitup'
require_relative 'plugins/user_intros/user_intros'
require_relative 'plugins/user_quotes/user_quotes'
require_relative 'plugins/ctcp_version'
require_relative 'plugins/regex_replace'
require_relative 'plugins/link_titling'

$BOT_VERSION = 1.30
$BOT_STARTTIME = Time.now
$BOT_ADMINS = []
$BOT_PLUGINS = [
	CommandHelp,
	BotInfo,
	BotAdmin,
	Catch22,
	UrbanDictionary,
	WolframAlpha,
	Weather,
	GoogleSearch,
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
	UserIntros,
	UserQuotes,
	CTCPVersion,
	LastSeen,
	LinkTitling,
	RegexReplace
]

options = {
	:links => true,
	:seen => true,
	:regex => true,
	:intros => true,
	:quotes => true
}

OptionParser.new do |opts|
	opts.banner = "Usage: $0 <irc server> <channels> [options]"

	opts.on('-a', '--admin NICK', 'Set the bot\'s admin.') do |a|
		$BOT_ADMINS = a.split(',')
	end

	opts.on('-t', '--no-link-titles', 'Do not title links.') do |t|
		options[:links] = false
	end

	opts.on('-s', '--no-seen', 'Disable the !seen command.') do |s|
		options[:seen] = false
	end

	opts.on('-r', '--no-regex-replace', 'Disable sed-like regexes for typos.') do |r|
		options[:regex] = false
	end

	opts.on('-i', '--no-intros', 'No custom user intros.') do |i|
		options[:intros] = false
	end

	opts.on('-q', '--no-quotes', 'No !quote collection.') do |q|
		options[:quotes] = false
	end
end.parse!

bot = Cinch::Bot.new do
	configure do |c|
		c.nick = 'yossarian-bot'
		c.realname = 'yossarian-bot'
		c.max_messages = 1
		c.server = ARGV[0]
		c.channels = ARGV[1].split(',')
		c.plugins.prefix = /^!/
		c.plugins.plugins = $BOT_PLUGINS.dup

		unless options[:seen]
			c.plugins.plugins.delete(LastSeen)
		end

		unless options[:links]
			c.plugins.plugins.delete(LinkTitling)
		end

		unless options[:regex]
			c.plugins.plugins.delete(RegexReplace)
		end

		unless options[:intros]
			c.plugins.plugins.delete(UserIntros)
		end

		unless options[:quotes]
			c.plugins.plugins.delete(UserQuotes)
		end
	end

	on :message, /^[!.:,]bots$/ do |m|
		m.reply 'Reporting in! [Ruby] See !help for commands.'
	end
end

bot.start
