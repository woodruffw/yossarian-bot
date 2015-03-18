#  -*- coding: utf-8 -*-
#  shakespearean_insults.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Shakespearean insults for yossarian-bot.
#  shakespearean_insults.yml taken from 'insult-generator' by Arvind Kunday.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'yaml'

require_relative '../yossarian_plugin'

class ShakespeareanInsults < YossarianPlugin
	include Cinch::Plugin

	@@insults_file = File.expand_path(File.join(File.dirname(__FILE__), 'shakespearean_insults.yml'))

	def initialize(*args)
		super
		@insults = YAML::load_file(@@insults_file);
	end

	def usage
		'!insult - Generate a Shakespearean insult.'
	end

	def match?(cmd)
		cmd =~ /^(!)?insult$/
	end

	match /insult$/, method: :shakespearean_insult

	def shakespearean_insult(m)
		col1 = @insults['column1'].sample
		col2 = @insults['column2'].sample
		col3 = @insults['column3'].sample

		m.reply "Thou art a #{col1}, #{col2} #{col3}!", true
	end
end
