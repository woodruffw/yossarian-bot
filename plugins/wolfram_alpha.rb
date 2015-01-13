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

	def usage
		'!wa <query> - Ask Wolfram|Alpha about <query>. Alias: !wolfram.'
	end

	def match?(cmd)
		cmd =~ /^(!)?(wolfram)|(wa)$/
	end

	match /wa (.+)/, method: :wolfram_alpha
	match /wolfram (.+)/, method: :wolfram_alpha

	def wolfram_alpha(m, query)
		if ENV.has_key?('WOLFRAM_ALPHA_APPID_KEY')
			Wolfram.appid = ENV['WOLFRAM_ALPHA_APPID_KEY']
			result = Wolfram.fetch(query).pods[1]

			if result == nil || result.plaintext.empty?
				m.reply "#{m.user.nick}: Wolfram|Alpha has nothing for #{query}"
			else
				m.reply "#{m.user.nick}: #{result.plaintext.gsub(/[\t\r\n]/, '')}"
			end
		else
			m.reply 'Internal error (missing API key).'
		end
	end
end
