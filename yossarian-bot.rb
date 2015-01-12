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

require_relative 'yossarian-helpers'
require_relative 'plugins/yossarianbuiltins'
require_relative 'plugins/catch22'
require_relative 'plugins/urbandictionary'
require_relative 'plugins/wolframalpha'
require_relative 'plugins/weather'
require_relative 'plugins/google'
require_relative 'plugins/magic8ball'
require_relative 'plugins/merriamwebster'
require_relative 'plugins/cleverbot'
require_relative 'plugins/fortune'

BOT_VERSION = 0.7

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
			Fortune
		]
	end

	# on :message, /^[.!:]help$/ do |m|
	# 	User(m.user.nick).send(list_help, true)
	# end

	# on :message, /^[.!:]help (.+)/ do |m, cmd|
	# 	User(m.user.nick).send(cmd_help(cmd), true)
	# end

	# on :message, /^[.!:]bots/ do |m|
	# 	m.reply "Reporting in! [Ruby] Use !help for commands."
	# end

	# on :message, "!author" do |m|
	# 	m.reply "Author: cpt_yossarian (woodruffw)"
	# end

	on :message, "!botver" do |m|
		m.reply "yossarian-bot version #{BOT_VERSION}"
	end

	on :message, /^!s(?:ou)?rc/ do |m|
		m.reply "https://github.com/woodruffw/yossarian-bot"
	end

	on :message, /^!say (.+)/ do |m, msg|
		m.reply msg
	end

	on :message, /^!pmsg (.+?) (.+)/ do |m, user, msg|
		User(user).send "#{user}: #{msg} (#{m.user.nick})"
	end

	on :message, /^!rot13 (.+)/ do |m, msg|
		m.reply "#{m.user.nick}: #{rot13(msg)}"
	end
	
	if options[:links]
		on :message, /(http(s)?:\/\/[^ \t]*)/ do |m, link|
			title = link_title(link)
			unless title.empty?
				m.reply "Title: \"#{title}\""
			end
		end
	end

	on :ctcp, "VERSION" do |m|
		m.reply "yossarian-bot version #{BOT_VERSION}"
	end
end

bot.start
