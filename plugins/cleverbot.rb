require 'cleverbot-api'

class Cleverbot
	include Cinch::Plugin

	match /cb (.+)/, method: :cleverbot
	match /cleverbot (.+)/, method: :cleverbot

	def cleverbot(m, query)
		cb = CleverBot.new
		m.reply "#{m.user.nick}: #{cb.think(query)}"
	end
end
