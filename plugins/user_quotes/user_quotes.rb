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
	@@user_quote_limit = 15
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
		if m.message =~ /!quote/
			return # we don't want to store quote queries, for obvious reasons
		else
			@@message_count += 1
		end

		if @quotes.has_key?(m.user.nick)
			if @quotes[m.user.nick].size < @@user_quote_limit
				@quotes[m.user.nick] << m.message
			else
				@quotes[m.user.nick].delete_at(rand(@quotes[m.user.nick].length))
				@quotes[m.user.nick].push(m.message)
			end
		else
			@quotes[m.user.nick] = [m.message]
		end

		if @@message_count == @@sync_interval
			sync_quotes_file
			@@message_count = 0
		end
	end

	match /quote$/, method: :random_quote

	def random_quote(m)
		user = @quotes.keys.sample
		quote = @quotes[user].sample

		m.reply "#{quote} [#{user}]"
	end

	match /quote (\S+)/, method: :random_quote_user

	def random_quote_user(m, nick)
		if @quotes.has_key?(nick)
			quote = @quotes[nick].sample
			m.reply "#{quote} [#{nick}]"
		else
			m.reply "I don\'t have any quotes for #{nick}."
		end
	end
end
