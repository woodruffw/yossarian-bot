class Fortune
	include Cinch::Plugin

	match /fortune/, method: :unix_fortune

	def unix_fortune(m)
		if system('which fortune 2> /dev/null')
			m.reply "#{m.user.nick}: #{`fortune`.gsub(/\n/, ' ')}"
		else
			m.reply 'Internal error (no fortune).'
		end
	end
end
