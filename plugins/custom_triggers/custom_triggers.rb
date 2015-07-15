#  -*- coding: utf-8 -*-
#  custom_triggers.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that user-definable triggers for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'yaml'

require_relative '../yossarian_plugin'

class CustomTriggers < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@triggers_file = File.expand_path(File.join(File.dirname(__FILE__), @bot.config.server, 'custom_triggers.yml'))
		@triggers = {}
	end

	def sync_triggers_file
		File.open(@triggers_file, "w+") do |file|
			file.write @triggers.to_yaml
		end
	end

	def usage
		'!trigger <command> - Manage custom triggers. Commands are add, rm, and list. Alias: !reply.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(trigger$)|(reply$)/
	end

	listen_to :connect, method: :initialize_triggers

	def initialize_triggers(m)
		if File.exist?(@triggers_file)
			@triggers = YAML::load_file(@triggers_file)
		else
			FileUtils.mkdir_p File.dirname(@triggers_file)
		end
	end

	match /trigger add (\S+) (.+)/, method: :add_trigger

	def add_trigger(m, trigger, response)
		if @triggers.has_key?(m.channel.to_s)
			@triggers[m.channel.to_s][trigger] = response
		else
			@triggers[m.channel.to_s] = {trigger => response}
		end

		m.reply "Added trigger for \'#{trigger}\' -> \'#{response}\'.", true
		sync_triggers_file
	end

	match /trigger rm (\S+)/, method: :rm_trigger

	def rm_trigger(m, trigger)
		if @triggers.has_key?(m.channel.to_s) && @triggers[m.channel.to_s].has_key?(trigger)
			@triggers[m.channel.to_s].delete(trigger)
			m.reply "Deleted the response associated with \'#{trigger}\'.", true
			sync_triggers_file
		else
			m.reply "I don\'t have a response to remove for \'#{trigger}\'.", true
		end
	end

	match /trigger list/, method: :list_triggers

	def list_triggers(m)
		if @triggers.empty?
			m.reply "I don\'t currently have any triggers.", true
		else
			m.reply @triggers[m.channel.to_s].keys.join(', '), true
		end
	end

	listen_to :channel

	def listen(m)
		if @triggers.has_key?(m.channel.to_s) && @triggers[m.channel.to_s].has_key?(m.message)
			m.reply "\u200B#{@triggers[m.channel.to_s][m.message]}"
		end
	end
end
