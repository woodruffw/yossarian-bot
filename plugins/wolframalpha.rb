require 'wolfram'

class WolframAlpha
	include Cinch::Plugin

	match /wa (.+)/, method: :wolfram_alpha
	match /wolfram (.+)/, method: :wolfram_alpha

	def wolfram_alpha(m, query)
		if ENV.has_key?('WOLFRAM_ALPHA_APPID_KEY')
			Wolfram.appid = ENV['WOLFRAM_ALPHA_APPID_KEY']
			result = Wolfram.fetch(query).pods[1]

			if result == nil || result.plaintext.empty?
				m.reply "Wolfram|Alpha has nothing for #{query}"
			else
				m.reply result.plaintext.gsub(/[\t\r\n]/, '')
			end
		else
			m.reply 'Internal error (missing API key).'
		end
	end
end
