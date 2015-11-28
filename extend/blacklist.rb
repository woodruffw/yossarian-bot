module Cinch
	module Plugin
		module ClassMethods
			def use_blacklist
				hook :pre, :for => [:match, :listen_to], :method => :not_blacklisted?
			end
		end

		def not_blacklisted?(m)
			!@bot.blacklist.include?(m.user.nick) && !@bot.blacklist.include?(m.user.host)
		end
	end
end
