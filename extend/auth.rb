module Cinch
	module Plugin
		module ClassMethods
			def use_auth
				hook :pre, :for => [:match], :method => :authenticated?
			end
		end

		def authenticated?(m)
			if @bot.admins.include?(m.user.nick) && User(m.user.nick).authed?
				return true
			else
				m.reply "You do not have permission to do that.", true
				return false
			end
		end
	end
end
