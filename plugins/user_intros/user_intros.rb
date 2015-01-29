#  user_intros.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides custom intros for users for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'yaml'

require_relative '../yossarian_plugin'

class UserIntros < YossarianPlugin
	include Cinch::Plugin

	@@user_intros_file = File.expand_path(File.join(File.dirname(__FILE__), 'user_intros.yml'))

	def initialize(*args)
		super
		@intros = {}
	end

	def sync_intros_file
		File.open(@@user_intros_file, "w+") do |file|
			file.write @intros.to_yaml
		end
	end

	def usage
		'!intro <intro> - Set a custom intro message for your nick. Prefix with \'rm\' to remove your intro.'
	end

	def match?(cmd)
		cmd =~ /^(!)?intro$/
	end

	listen_to :connect, method: :initialize_intros

	def initialize_intros(m)
		if File.exist?(@@user_intros_file)
			@intros = YAML::load_file(@@user_intros_file)
		end
	end

	match /intro (.+)/, method: :set_intro

	def set_intro(m, intro)
		@intros[m.user.nick] = intro
		m.reply "#{m.user.nick}: Your intro has been set to: #{intro}"
		sync_intros_file
	end

	match /rmintro/, method: :remove_intro

	def remove_intro(m)
		if @intros.has_key?(m.user.nick)
			@intros.delete(m.user.nick)
			m.reply "#{m.user.nick}: Your intro has been removed."
			sync_intros_file
		else
			m.reply "#{m.user.nick}: You don't currently have an intro."
		end
	end

	listen_to :join, method: :intro_user

	def intro_user(m)
		if @intros.has_key?(m.user.nick)
			m.reply @intros[m.user.nick]
		end
	end
end
