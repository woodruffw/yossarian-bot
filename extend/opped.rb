module Cinch
	module Plugin
		module ClassMethods
			def use_opped(silent: false)
				if silent
					hook :pre, :for => [:match], :method => :is_opped_silent?
				else
					hook :pre, :for => [:match], :method => :is_opped?
				end
			end
		end

		def is_opped_silent?(m)
			m.channel && m.channel.opped?(@bot.nick)
		end

		def is_opped?(m)
			if is_opped_silent?(m)
				return true
			else
				m.reply "I can\'t administrate this channel.", true
				return false
			end
		end
	end
end
