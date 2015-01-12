class YossarianBuiltins
	include Cinch::Plugin

	set :prefix, /^[.!:]/

	match /help$/, method: :help
	def help(m)
		m.reply 'Command info can be found at: https://github.com/woodruffw/yossarian-bot/blob/master/README.md', true
	end

	match /bots$/, method: :report_in
	def report_in(m)
		m.reply 'Reporting in! [Ruby] See !help for commands.'
	end

	match /author$/, method: :author
	def author(m)
		m.reply 'Author: cpt_yossarian (woodruffw).', true
	end
end
