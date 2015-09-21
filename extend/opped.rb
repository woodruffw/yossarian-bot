module Cinch
	module Plugin
		module ClassMethods
			def use_opped
				hook :pre, :for => [:match], :method => :is_opped?
			end
		end

		def is_opped?(m)
			if m.channel && m.channel.opped?(@bot.nick)
				return true
			else
				m.reply "I can\'t administrate this channel.", true
				return false
			end
		end
	end
end
