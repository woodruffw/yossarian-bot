#  -*- coding: utf-8 -*-
#  wolfram_alpha.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that provides Wolfram|Alpha interaction for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'wolfram'

require_relative 'yossarian_plugin'

class WolframAlpha < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	def initialize(*args)
		super
		@key = ENV['WOLFRAM_ALPHA_APPID_KEY']
	end

	def usage
		'!wa <query> - Ask Wolfram|Alpha about <query>. Alias: !wolfram.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(wolfram)|(wa)$/
	end

	match /wa (.+)/, method: :wolfram_alpha, strip_colors: true
	match /wolfram (.+)/, method: :wolfram_alpha, strip_colors: true

	def wolfram_alpha(m, query)
		if @key
			Wolfram.appid = @key
			result = Wolfram.fetch(query).pods[1]

			if result == nil || result.plaintext.empty?
				m.reply "Wolfram|Alpha has nothing for #{query}", true
			else
				m.reply result.plaintext.gsub(/[\t\r\n]/, ''), true
			end
		else
			m.reply 'Internal error (missing API key).'
		end
	end
end
