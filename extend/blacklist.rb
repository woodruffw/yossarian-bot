module Cinch
	module Plugin
		module ClassMethods
			def use_blacklist
				hook :pre, :method => :check_blacklist
			end
		end

		def check_blacklist(m)
			!@bot.blacklist.include?(m.user.nick) && !@bot.blacklist.include?(m.user.host)
		end
	end
end
