#  -*- coding: utf-8 -*-
#  user_quotes.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides a collection of queryable quotes
#  for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'yaml'

require_relative '../yossarian_plugin'

class UserQuotes < YossarianPlugin
	include Cinch::Plugin

	@@user_quotes_file = File.expand_path(File.join(File.dirname(__FILE__), 'user_quotes.yml'))
	@@user_quote_limit = 25
	@@sync_interval = 10
	@@message_count = 0

	def initialize(*args)
		super
		@quotes = {}
	end

	def sync_quotes_file
		File.open(@@user_quotes_file, "w+") do |file|
			file.write @quotes.to_yaml
		end
	end

	def usage
		'!quote [nick] - Retrieve a random quote. If a nick is provided, a quote from that user is retrieved.'
	end

	def match?(cmd)
		cmd =~ /^(!)?quote$/
	end

	listen_to :connect, method: :initialize_quotes

	def initialize_quotes(m)
		if File.exist?(@@user_quotes_file)
			@quotes = YAML::load_file(@@user_quotes_file)
		end
	end

	listen_to :channel

	def listen(m)
		chan = m.channel.to_s
		nick = m.user.nick

		if m.message =~ /^[!:.]/
			return # we don't want command messages, for obvious reasons
		else
			@@message_count += 1
		end

		if @quotes.has_key?(chan)
			if @quotes[chan].has_key?(nick)
				if @quotes[chan][nick].size < @@user_quote_limit
					@quotes[chan][nick] << m.message
				else
					@quotes[chan][nick].delete_at(rand(@quotes[chan][nick].length))
					@quotes[chan][nick].push(m.message)
				end
			else
				@quotes[chan][nick] = [m.message]
			end
		else
			@quotes[chan] = {}
		end

		if @@message_count == @@sync_interval
			sync_quotes_file
			@@message_count = 0
		end
	end

	match /quote$/, method: :random_quote

	def random_quote(m)
		chan = m.channel.to_s

		unless chan == nil or @quotes[chan] == nil
			nick = @quotes[chan].keys.sample
			quote = @quotes[chan][nick].sample
			m.reply "#{quote} [#{nick} on #{chan}]"
		else
			m.reply "I don\'t have any quotes yet. Check back in a bit."
		end
	end

	match /quote (\S+)/, method: :random_quote_user

	def random_quote_user(m, nick)
		chan = m.channel.to_s

		if @quotes.has_key?(chan) && @quotes[chan].has_key?(nick)
			quote = @quotes[chan][nick].sample
			m.reply "#{quote} [#{nick}]"
		else
			m.reply "I don\'t have any quotes for #{nick} on this channel."
		end
	end
end
