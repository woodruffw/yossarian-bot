module Cinch
	class HandlerList
		def dispatch(event, msg = nil, *arguments)
			threads = []

			if handlers = find(event, msg)
				if msg && msg.user
					if $BLACKLIST.include?(msg.user.nick)
						return threads
					end
				end

				already_run = Set.new
				handlers.each do |handler|
					next if already_run.include?(handler.block)
					already_run << handler.block
					# calling Message#match multiple times is not a problem
					# because we cache the result
					if msg
						captures = msg.match(handler.pattern.to_r(msg), event, handler.strip_colors).captures
					else
						captures = []
					end

					threads << handler.call(msg, captures, arguments)
				end
			end

			threads
		end
	end
end
